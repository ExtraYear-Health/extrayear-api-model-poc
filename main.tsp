import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";

using TypeSpec.Http;
using TypeSpec.Rest;

// Define a namespace for your API
@service({
  title: "Example API",
  version: "1.0.0"
})
namespace MyExampleApi {
  @route("/hello")
  namespace HelloWorld {
    @get
    @doc("Say hello to the user.")
    op sayHello(): string;
  }

  @route("/users")
  namespace Users {
    @get
    @doc("Retrieve all users.")
    op getUsers(): string[];

    @post
    @doc("Add a new user.")
    op addUser(@body user: { name: string }): string;
  }
}
