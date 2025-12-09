package com.example.config

import com.example.domain.services.models.ErrorResponse
import io.ktor.server.application.Application
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.response.*

fun Application.configureStatusPages() {
    install(StatusPages) {
        exception<kotlinx.serialization.SerializationException> { call, cause ->
            call.application.log.error("Error de serialización", cause)
            call.respond(
                HttpStatusCode.BadRequest,
                ErrorResponse(
                    success = false,
                    message = "Error en el formato de datos: ${cause.message}"
                )
            )
        }

        exception<io.ktor.server.plugins.BadRequestException> { call, cause ->
            call.application.log.error("Bad Request", cause)
            call.respond(
                HttpStatusCode.BadRequest,
                ErrorResponse(
                    success = false,
                    message = "Solicitud inválida: ${cause.message}"
                )
            )
        }

        exception<IllegalArgumentException> { call, cause ->
            call.respond(
                HttpStatusCode.BadRequest,
                ErrorResponse(
                    success = false,
                    message = cause.message ?: "Solicitud inválida"
                )
            )
        }

        exception<Throwable> { call, cause ->
            call.application.log.error("Error no manejado", cause)
            call.respond(
                HttpStatusCode.InternalServerError,
                ErrorResponse(
                    success = false,
                    message = "Error interno del servidor: ${cause.message}"
                )
            )
        }

        status(HttpStatusCode.NotFound) { call, _ ->
            call.respond(
                HttpStatusCode.NotFound,
                ErrorResponse(
                    success = false,
                    message = "Recurso no encontrado"
                )
            )
        }

        status(HttpStatusCode.Unauthorized) { call, _ ->
            call.respond(
                HttpStatusCode.Unauthorized,
                ErrorResponse(
                    success = false,
                    message = "No autorizado - Token inválido o expirado"
                )
            )
        }
    }
}