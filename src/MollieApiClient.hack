namespace Mollie\Api;

use namespace HH\Lib\{
  C,
  Dict,
  Regex,
  Str,
};
use namespace Mollie\Api\{
  Endpoints,
  Types
};
use type Mollie\Api\Exceptions\ApiException;
use function curl_init;
use function curl_setopt;
use function curl_getinfo;
use function HH\Asio\curl_exec;
use function json_decode;
use const CURLOPT_CUSTOMREQUEST;
use const CURLOPT_HTTPHEADER;
use const CURLINFO_HTTP_CODE;
use const CURLOPT_POST;
use const CURLOPT_POSTFIELDS;
use const CURLOPT_RETURNTRANSFER;

class MollieApiClient {
  /**
   * Version of our client.
   */
  const string CLIENT_VERSION = '1.0.0';

  /**
   * Endpoint of the remote API.
   */
  const string API_ENDPOINT = 'https://api.mollie.com';

  /**
   * Version of the remote API.
   */
  const string API_VERSION = 'v2';

  /**
   * HTTP status codes
   */
  const int HTTP_NO_CONTENT = 204;

  /**
   * Default response timeout (in seconds).
   */
  const int TIMEOUT = 10;

  /**
   * Default connect timeout (in seconds).
   */
  const int CONNECT_TIMEOUT = 2;

  // TODO
  // create http client for hhvm
  //protected $httpClient;

  /**
   * @var string
   */
  protected string $apiEndpoint = self::API_ENDPOINT;

  <<__LateInit>>
  public Endpoints\PaymentEndpoint $payments;
  <<__LateInit>>
  public Endpoints\MethodEndpoint $methods;
  <<__LateInit>>
  public Endpoints\ProfileMethodEndpoint $profileMethods;
  <<__LateInit>>
  public Endpoints\CustomerEndpoint $customers;
  <<__LateInit>>
  public Endpoints\CustomerPaymentsEndpoint $customerPayments;
  <<__LateInit>>
  public Endpoints\SettlementsEndpoint $settlements;
  <<__LateInit>>
  public Endpoints\SettlementPaymentEndpoint $settlementPayments;
  <<__LateInit>>
  public Endpoints\SubscriptionEndpoint $subscriptions;
  <<__LateInit>>
  public Endpoints\MandateEndpoint $mandates;
  <<__LateInit>>
  public Endpoints\ProfileEndpoint $profiles;
  <<__LateInit>>
  public Endpoints\OrganizationEndpoint $organizations;
  <<__LateInit>>
  public Endpoints\PermissionEndpoint $permissions;
  <<__LateInit>>
  public Endpoints\InvoiceEndpoint $invoices;
  <<__LateInit>>
  public Endpoints\OnboardingEndpoint $onboarding;
  <<__LateInit>>
  public Endpoints\OrderEndpoint $orders;
  <<__LateInit>>
  public Endpoints\OrderLineEndpoint $orderLines;
  <<__LateInit>>
  public Endpoints\OrderPaymentEndpoint $orderPayments;
  <<__LateInit>>
  public Endpoints\ShipmentEndpoint $shipments;
  <<__LateInit>>
  public Endpoints\RefundEndpoint $refunds;
  <<__LateInit>>
  public Endpoints\PaymentRefundEndpoint $paymentRefunds;
  <<__LateInit>>
  public Endpoints\PaymentCaptureEndpoint $paymentCaptures;
  <<__LateInit>>
  public Endpoints\ChargebackEndpoint $chargebacks;
  <<__LateInit>>
  public Endpoints\PaymentChargebackEndpoint $paymentChargebacks;
  <<__LateInit>>
  public Endpoints\OrderRefundEndpoint $orderRefunds;
  <<__LateInit>>
  public Endpoints\WalletEndpoint $wallets;

  protected string $apiKey = '';

  /**
   * True if an OAuth access token is set as API key.
   */
  protected ?bool $oauthAccess;

  protected vec<string> $versionStrings = vec[];

  protected int $lastHttpResponseStatusCode = 0;

  public function __construct() {
    $this->payments = new Endpoints\PaymentEndpoint($this);
    $this->methods = new Endpoints\MethodEndpoint($this);
    $this->profileMethods = new Endpoints\ProfileMethodEndpoint($this);
    $this->customers = new Endpoints\CustomerEndpoint($this);
    $this->settlements = new Endpoints\SettlementsEndpoint($this);
    $this->settlementPayments = new Endpoints\SettlementPaymentEndpoint($this);
    $this->subscriptions = new Endpoints\SubscriptionEndpoint($this);
    $this->customerPayments = new Endpoints\CustomerPaymentsEndpoint($this);
    $this->mandates = new Endpoints\MandateEndpoint($this);
    $this->invoices = new Endpoints\InvoiceEndpoint($this);
    $this->permissions = new Endpoints\PermissionEndpoint($this);
    $this->profiles = new Endpoints\ProfileEndpoint($this);
    $this->onboarding = new Endpoints\OnboardingEndpoint($this);
    $this->organizations = new Endpoints\OrganizationEndpoint($this);
    $this->orders = new Endpoints\OrderEndpoint($this);
    $this->orderLines = new Endpoints\OrderLineEndpoint($this);
    $this->orderPayments = new Endpoints\OrderPaymentEndpoint($this);
    $this->orderRefunds = new Endpoints\OrderRefundEndpoint($this);
    $this->shipments = new Endpoints\ShipmentEndpoint($this);
    $this->refunds = new Endpoints\RefundEndpoint($this);
    $this->paymentRefunds = new Endpoints\PaymentRefundEndpoint($this);
    $this->paymentCaptures = new Endpoints\PaymentCaptureEndpoint($this);
    $this->chargebacks = new Endpoints\ChargebackEndpoint($this);
    $this->paymentChargebacks = new Endpoints\PaymentChargebackEndpoint($this);
    $this->wallets = new Endpoints\WalletEndpoint($this);

    $this->addVersionString('Mollie/' . self::CLIENT_VERSION);
    $this->addVersionString('HHVM/' . \HHVM_VERSION);
  }

  public function setApiEndpoint(
    string $url
  ): this {
    $this->apiEndpoint = Str\trim($url) |> Str\trim_right($$, '/');

    return $this;
  }

  public function getApiEndpoint(): string {
    return $this->apiEndpoint;
  }

  /**
   * $apiKey The Mollie API key, starting with 'test_' or 'live_'
   */
  public function setApiKey(
    string $apiKey
  ): this {
    $apiKey = Str\trim($apiKey);

    if(!Regex\matches($apiKey, re'/^(live|test)_\w{30,}$/')) {
      throw new ApiException('Invalid API key: \''. $apiKey . '\'. An API key must start with \'test_\' or \'live_\' and must be at least 30 characters long.');
    }

    $this->apiKey = $apiKey;
    $this->oauthAccess = false;

    return $this;
  }

  /**
   * $accessToken OAuth access token, starting with 'access_'
   */
  public function setAccessToken(
    string $accessToken
  ): this {
    $accessToken = Str\trim($accessToken);

    if(!Regex\matches($accessToken, re'/^access_\w+$/')) {
      throw new ApiException('Invalid OAuth access token: \'' . $accessToken . '\'. An access token must start with \'access_\'.');
    }

    $this->apiKey = $accessToken;
    $this->oauthAccess = true;

    return $this;
  }

  /**
   * Returns null if no API key has been set yet.
   */
  public function usesOAuth(): ?bool {
    return $this->oauthAccess;
  }

  private function addVersionString(
    string $versionString
  ): this {
    $this->versionStrings[] = Str\replace_every(
      $versionString,
      dict[
        ' ' => '-',
        "\t" => '-',
        "\n" => '-',
        "\r" => '-'
      ]
    );

    return $this;
  }

  /**
   * Perform an http call. This method is used by the resource specific classes. Please use the $payments property to
   * perform operations on payments.
   */
  public function performHttpCallAsync(
    Types\HttpMethod $httpMethod,
    string $apiMethod,
    ?string $httpBody = null
  ): Awaitable<dict<string, mixed>> {
    $url = $this->apiEndpoint . '/' . self::API_VERSION . '/' . $apiMethod;

    return $this->performHttpCallToFullUrlAsync($httpMethod, $url, $httpBody);
  }

  /**
   * Perform an http call to a full url. This method is used by the resource specific classes.
   */
  public async function performHttpCallToFullUrlAsync(
    Types\HttpMethod $httpMethod,
    string $url,
    ?string $httpBody = null
  ): Awaitable<dict<string, mixed>> {
    if(Str\is_empty($this->apiKey)) {
      throw new ApiException('You have not set an API key or OAuth access token. Please use setApiKey() to set the API key.');
    }

    $userAgent = Str\join($this->versionStrings, ' ');

    if($this->usesOAuth()) {
      $userAgent .= ' OAuth/2.0';
    }

    $headers = dict[
      'Accept' => 'application/json',
      'Authorization' => 'Bearer ' . $this->apiKey,
      'User-Agent' => $userAgent,
    ];

    $ch = curl_init($url);

    if($httpMethod !== Types\HttpMethod::GET) {
      if($httpBody !== null && !Str\is_empty($httpBody)) {
        $headers['Content-Type'] = 'application/json';
        $headers['Content-Length'] = Str\length($httpBody);

        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $httpBody);
      }
    }

    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $httpMethod as string);
    curl_setopt($ch, CURLOPT_HTTPHEADER, Dict\map_with_key(
      $headers,
      ($key, $value) ==> $key . ': ' . $value
    ) |> vec($$));

    $response = await curl_exec($ch);

    $this->lastHttpResponseStatusCode = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);

    if($this->lastHttpResponseStatusCode === self::HTTP_NO_CONTENT || Str\is_empty($response)) {
      throw new ApiException('Did not receive API response.');
    } else {
      $responseDict = $this->parseResponseBody($response);

      if($this->lastHttpResponseStatusCode >= 400) {
        throw new ApiException($response, $this->lastHttpResponseStatusCode);
      } else {
        return $responseDict;
      }
    }
  }

  private function parseResponseBody(
    string $response
  ): dict<string, mixed> {
    $result = json_decode($response, true);

    if($result === null) {
      throw new ApiException('Did not recive Api valid json.');
    } else {
      return dict($result);
    }
  }
}
