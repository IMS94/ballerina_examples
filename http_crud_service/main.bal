import ballerina/http;
import ballerina/log;
import http_crud_service.types;
import ballerina/uuid;

# The product service
service /products on new http:Listener(8080) {

    private map<types:Product> products = {};

    # List all products
    # + return - List of products
    resource function get .() returns types:Product[] {
        return self.products.toArray();
    }


    # Add a new product
    #
    # + product - Product to be added
    # + return - http created or bad request
    resource function post .(@http:Payload types:Product product) returns types:Created|types:BadRequest {
        if product.name.length() == 0 || product.description.length() == 0 {
            log:printWarn("Product name or description is not present", product = product);
            return <types:BadRequest>{
                body: {
                    'error: {
                        code: "INVALID_NAME",
                        message: "Product name and description are required"
                    }
                }
            };
        }

        if product.price.amount < 0.0 {
            log:printWarn("Product price cannot be negative", product = product);
            return <types:BadRequest>{
                body: {
                    'error: {
                        code: "INVALID_PRICE",
                        message: "Product price cannot be negative"
                    }
                }
            };
        }

        log:printDebug("Adding new product", product = product);
        product.id = uuid:createType1AsString();
        self.products[<string>product.id] = product;
        log:printInfo("Added new product", product = product);

        string productUrl = string `/products/${<string>product.id}`;
        return <types:Created>{
            headers: {
                location: productUrl
            }
        };
    }

    # Update a product
    #
    # + product - Updated product
    # + return - Error if product is invalid
    resource function put .(@http:Payload types:Product product) returns types:BadRequest? {
        if product.id is () || !self.products.hasKey(<string>product.id) {
            log:printWarn("Invalid product provided for update", product = product);
            return {
                body: {
                    'error: {
                        code: "INVALID_PRODUCT",
                        message: "Invalid product"
                    }
                }
            };
        }

        log:printInfo("Updating product", product = product);
        self.products[<string>product.id] = product;
        return;
    }

    # Deletes a product
    #
    # + id - Product ID
    # + return - Ok or bad request
    resource function delete [string id]() returns types:BadRequest? {
        if !self.products.hasKey(<string>id) {
            log:printWarn("Invalid product ID to be deleted", id = id);
            return {
                body: {
                    'error: {
                        code: "INVALID_ID",
                        message: "Invalud product id"
                    }
                }
            };
        }

        log:printDebug("Deleting product", id = id);
        types:Product removed = self.products.remove(id);
        log:printDebug("Deleted product", product = removed);
        return;
    }
}
