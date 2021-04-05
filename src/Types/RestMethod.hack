namespace Mollie\Api\Types;

enum RestMethod: HttpMethod as HttpMethod {
  CREATE = HttpMethod::POST;
  UPDATE = HttpMethod::PATCH;
  READ = HttpMethod::GET;
  LIST = HttpMethod::GET;
  DELETE = HttpMethod::DELETE;
}
