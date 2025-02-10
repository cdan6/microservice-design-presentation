workspace "Load Case Manager" "A service to manage reusable load cases" {
    !identifiers hierarchical

    model {
        db = softwareSystem "DB" {
            description "DB"
            tags database level1
        }
        lcm = softwareSystem "LCM" {
            description "Manages Load Cases"
            driver = container "DB Driver" {
                description "DB Driver"
                tags level1
                -> db
            }
            businessLogic = container "Business Logic" {
                description "Implements the internal logic"
                tags level1
                -> driver
            }
            api = container "Public API" {
                description "Exposes features to clients"
                tags level1
                -> businessLogic
            }
            api2 = container "Additional API" {
                description "Uses a different tech"
                tags level2
                -> businessLogic
            }

            cli = container "CLI" {
                description "Command Line Interface"
                tags level3
                tags executable
                -> businessLogic "" ""
            }
        }

        client = softwareSystem "Client" {
            description "User or program"
            tags level1
             -> lcm.api "" "" external
        }

        admin = person "Admin" {
            description "Administrator of the instance"
            tags level3
             -> lcm.cli "" "" external
        }

        bot = softwareSystem "Bot" {
            description "Consumer"
            tags bot level2
             -> lcm.api2 "" "" external
        }
    }

    views {
        theme default
        styles {
            element external {
                background grey
                shape Box
            }
            element database {
                shape Cylinder
            }
            element in_browser {
                shape WebBrowser
            }
            element executable {
                shape Diamond
            }
            element bot {
                shape Robot
            }
            relationship Relationship {
                routing Orthogonal
                style solid
            }
            relationship external {
                routing Curved
                position 40
            }
        }
        systemContext lcm "LCMContext" {
            include *
        }
        container lcm "LCMContainers1" {
            include element.tag==level1
        }
        container lcm "LCMContainers2" {
            include element.tag==level2
            include element.tag==level1
        }
        container lcm "LCMContainers3" {
            include element.tag==level3
            include element.tag==level1
        }
    }

    configuration {
        scope softwaresystem
    }

}
