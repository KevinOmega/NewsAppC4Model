workspace "NewsSystem" "Description" {

   model {
        u = person "Usuario"
        ss = softwareSystem "Sistema de Software" {
        
            api_g = container "Aplicación Web" {
                technology "Angula js"
                description "Gestiona las solicitudes del cliente y actúa como punto de entrada"
                tags "webapp"
            }

            message_bus = container "Bus de Mensajes" {
                technology "RabbitMQ"
                description "Transporte para eventos de negocio"
            }
    
            #Kevin
            client_service = container "Servicio de Cliente" {
                technology "C#/.NET"
                description "Gestiona la información del cliente"

                # Componentes
                 client_request_handler = component "ClientRequestHandler" {
                    description "Recibe información del cliente, el correo electrónico y la temática a la que se desea suscribir mediante solicitudes POST."
                    technology "C#/.NET"
                }

                topicsubscriber = component "TopicSubscriber" {
                    description "Envía la información al broker de mensajería."
                    technology "C#/.NET"
                }
                api_g -> client_request_handler "Envía información del cliente usando [HTTPS POST]"
                client_request_handler -> topicsubscriber "Envía información del cliente al broker de mensajería"
            }
    
            #Kevin
            historic_service = container "Servicio Histórico" {
                technology "Python"
                description "Proporciona noticias históricas para los clientes"
                # Componentes
                news_request_handler = component "NewsRequestHandler" {
                    description "Recibe la informacion de las noticias diarias enviadas al usuario y las envía al repositorio de noticias."
                    technology "Python"
                }

                news_repository = component "NewsRepository" {
                    description "Almacena noticias por usuario y recupera el historial de noticias de los usuarios."
                    technology "Python"
                }
                news_sender = component "NewsSender" {
                    description "Solicita el historial de noticias de un usuario y lo envía."
                    technology "Python"
                }
                message_bus -> news_request_handler "Envía noticias diarias"
                news_request_handler -> message_bus "Confirma la recepción de noticias"
                news_request_handler -> news_repository "Envia datos al repositorio de noticias "
                news_sender -> news_repository "Solicita historial de noticias"
                news_sender -> api_g -> "Envia historial de noticias a traves de [HTTPS GET]"

            }
            
    
            #Juan
            email_service = container "Servicio de Correo" {
                technology "Java, Spring Boot"
                description "Envía notificaciones por correo electrónico a los clientes"
            }
    
            #Juan
            news_service = container "Servicio de Noticias" {
                technology "Java, Spring Boot"
                description "Crea temas para el cliente y obtiene noticias"
            }
    
            
    
            news_historic_db = container "BD Histórica de Noticias" {
                technology "Postgres"
                description "Almacena información sobre noticias diarias"
                tags "database"
            }
    
            topic_db = container "Base de Datos de Temas" {
                technology "Postgres"
                description "Almacena datos con los temas seleccionados por el cliente"
                tags "database"
            }
    
            historic_service -> api_g "Consulta historial de noticias vía [GET]"
            historic_service -> news_historic_db "Almacena datos en"
           
            topicsubscriber -> message_bus "Envia información del cliente al bus de mensajes"

            // Histórico de noticias
            news_repository -> news_historic_db "Almacena datos en"

           
            message_bus -> email_service "Envía evento de actualización de noticias"
            message_bus -> historic_service "Envía eventos de actualización de noticias"
            message_bus -> news_service "Recibe eventos de actualización del cliente"
            news_service -> topic_db "Almacena datos en"
        }

    api = softwareSystem "API de Noticias" {
        tags "external"
    }

    u -> ss "Usa"
    ss -> api "Obtiene noticias"
    u -> api_g "Se subscribe a noticias mediante [HTTPS POST]"
    email_service -> u "Envía correos electrónicos usando [Protocolo de Correo]"
    api_g -> u "Solicita historial de noticias a tráves [HTTPS GET]"
    api -> news_service "Obtiene noticias para el cliente usando [síncrono, JSON/HTTPS]"
}


    views {
        systemContext ss "Diagram1" {
            include *
            autolayout lr
        }
        
        container ss "Diagram2"{
            include *
            autolayout lr
        }

        component client_service "ClientService" {
            include *
            autolayout lr
        }
        component historic_service "HistoricService" {
            include *
            autolayout lr
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