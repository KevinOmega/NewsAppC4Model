workspace "NewsSystem" "Description" {

model {
        u = person "User"
        api = softwareSystem "News API" {
        tags "external"
    }
        external_mail = softwareSystem "External Mail Service" {
            description "External email service used to send notifications to customers."
            tags "external"
        }
        ss = softwareSystem "News Subscription System" {
            description "System that allows users to subscribe to news topics and receive daily updates via email."
        
            api_g = container "Web Application" {
                technology "AngularJS"
                description "Handles client requests and acts as the entry point."
                tags "webapp"
            }

            message_bus = container "Message Bus" {
                technology "RabbitMQ"
                description "Transport for business events."
            }
            news_historic_db = container "News Historic Database" {
                technology "Postgres"
                description "Stores information about daily news."
                tags "database"
            }
    
            topic_db = container "Topic Database" {
                technology "Postgres"
                description "Stores data with topics selected by the client."
                tags "database"
            }

            client_service = container "Client Service" {
                technology "C#/.NET"
                description "Manages client information."

                client_request_handler = component "Client Request Handler" {
                    description "Receives client information, email, and the topic to subscribe via POST requests."
                    technology "C#/.NET"
                }

                topic_subscriber = component "Topic Subscriber" {
                    description "Sends client information to the message broker."
                    technology "C#/.NET"
                }
                api_g -> client_request_handler "Sends client information using [HTTPS POST]"
                client_request_handler -> topic_subscriber "Sends client information to the message broker."
            }
    
            historic_service = container "Historic Service" {
                technology "Python"
                description "Provides historical news for clients."

                news_request_handler = component "News Request Handler" {
                    description "Receives daily news information sent to the user and sends it to the news repository."
                    technology "Python"
                }

                news_repository = component "News Repository" {
                    description "Stores news by user and retrieves the user's news history."
                    technology "Python"
                }
                news_sender = component "News Sender" {
                    description "Requests the user's news history and sends it."
                    technology "Python"
                }
                message_bus -> news_request_handler "Sends daily news."
                news_request_handler -> message_bus "Confirms the receipt of news."
                news_request_handler -> news_repository "Sends data to the news repository."
                news_sender -> news_repository "Requests news history."
                news_sender -> api_g "Sends news history via [HTTPS GET]"
            }
    
            email_service = container "Email Service" {
                technology "Node.js, Express"
                description "Sends email notifications to clients."

                email_sender = component "Email Sender" {
                    description "Sends emails to clients with selected news."
                    technology "Node.js, Express, Nodemailer"
                }
                news_receiver = component "News Receiver" {
                    description "Receives news from RabbitMQ and processes it to send via email."
                    technology "Node.js, Express, RabbitMQ"
                }
                message_bus -> news_receiver "Sends news to be processed."
                news_receiver -> email_sender "Sends processed news to be sent via email."
                email_sender -> external_mail "Sends news information."
            }
    
            news_service = container "News Service" {
                technology "Java, Spring Boot"
                description "Processes user preferences and stores them"
                preference_handler = component "PreferenceHandler" {
                    description "Processes user preferences from the messaging broker queue and saves the selected topic record."
                    technology "Java, Spring Boot"
                }

                news_fetcher = component "NewsFetcher" {
                    description "Queries the external news service daily based on user preferences."
                    technology "Java, Spring Boot"
                }

                news_publisher = component "NewsPublisher" {
                    description "Sends the obtained news to another queue in the messaging broker."
                    technology "Java, Spring Boot"
                }
                preference_handler -> news_fetcher "Queries users with specific preferences"
                message_bus -> preference_handler "Receives user preferences from the queue"
                preference_handler -> topic_db "Stores the selected topic"
                news_fetcher -> api "Fetches news related to the selected topic"
                news_fetcher -> news_publisher "Sends fetched news"
                news_publisher -> message_bus "Publishes news to the messaging broker queue"
                news_fetcher -> preference_handler "Queries users with specific preferences"
            }
    
           
            topic_subscriber -> message_bus "Sends client information to the message bus"

            // News history
            news_repository -> news_historic_db "Stores data in"

           
 
        }

    

    u -> api_g "Subscribes to news via [HTTPS POST]"
    api_g -> u "Requests news history via [HTTPS GET]"
    news_service -> api "Requests news via [HTTP GET]"
    external_mail -> u "Sends email notifications via [SMTP]"
}


    views {
        properties {
            "plantuml.url" "C:\Users\TUF\OneDrive\Documentos\Projects\C4\clientService"
            "mermaid.url" "http://localhost:3000"
        }

        systemContext ss "Diagram1" {
            include *
            // autolayout rl
            title "Context Diagram for News Subscription System"
        }
        
        container ss "ContainerDiagram" {
            include *
            // autolayout rl
            title "Container Diagram for Software System"
        }

        component client_service "ClientService" {
            include *
            autolayout lr
            title "Component Diagram for Client Service"
        }
        component historic_service "HistoricService" {
            include *
            autolayout lr
            title "Component Diagram for Historic Service"
        }
        component news_service "NewsService" {
            include *
            // autolayout lr
            title "Component Diagram for News Service"
        }
        component email_service "EmailService" {
            include *
            autolayout lr
            title "Component Diagram for Email Service"
        }

        image client_request_handler "ClientRequestHandler"{
            image "./diagrams/ClientService/ClientRequestHandler.png"
            title  "Class Diagram for ClientRequestHandler"
        }
        image topic_subscriber "TopicSubscriber"{
            image "./diagrams/TopicSubscriber.png"
            title  "Class Diagram for TopicSubscriber"
        }
        
        styles {
            element "Element"{
                color white
                background #438cd4
            }
            
            element "Person"{
                background #08427b
                shape person
            }

            element "Image"{
                fontSize 20
                width 1000
                height 1000
            }
            element "external"{
                background #999999
            }
            element "database"{
                shape cylinder
            }
            element "webapp"{
                shape WebBrowser
            }
            
        }
        
        
    }

}