import ballerina/graphql;

service /graphql on new graphql:Listener(9090) {
    
    private Product product;

    public function init() {
        self.product = new ("Orange", "Fresh Orange");
    }

    resource function get product () returns Product {
        return self.product;
    }

    remote function updateName(string name) returns Product {
        self.product.setName(name);
        return self.product;
    }
}

public service class Product {

    private string name;
    private string description;

    public function init(string name, string description) {
        self.name = name;
        self.description = description;
    }

    resource function get name() returns string { 
        return self.name;
    }

    resource function get description() returns string { 
        return self.description;
    }

    function setName(string name) {
        self.name = name;
    }
}
