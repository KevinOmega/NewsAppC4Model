workspace "NewsSystem" "Description" {

   model {
        u = person "Usuario"
        ss = softwareSystem "Sistema de Software" {
        
            api_g = container "Pasarela de API" {
                technology "Kubernetes"
                description "Gestiona las solicitudes del cliente y actúa como punto de entrada"
            }
    
            #Kevin
            client_service = container "Servicio de Cliente" {
                technology "C#/.NET"
                description "Gestiona la información del cliente"
            }
    
            #Kevin
            historic_service = container "Servicio Histórico" {
                technology "Python"
                description "Proporciona noticias históricas para los clientes"
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
    
            message_bus = container "Bus de Mensajes" {
                technology "RabbitMQ"
                description "Transporte para eventos de negocio"
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
    
            api_g -> client_service ""
            historic_service -> api_g "Consulta historial de noticias vía [GET]"
            historic_service -> news_historic_db "Almacena datos en"
            client_service -> message_bus ""
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
    u -> api_g "Usa [HTTPS POST]"
    email_service -> u "Envía correos electrónicos usando [Protocolo de Correo]"
    api_g -> u "Usa [HTTPS GET]"
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
        }
        
        
    }

}