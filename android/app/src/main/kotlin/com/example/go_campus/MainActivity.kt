package com.example.go_campus

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ObjectInputStream
import java.io.ObjectOutputStream
import java.net.Socket
import org.example.Parceiro
import org.example.cliente.PedidoDeOperacao
import org.example.cliente.PedidoDeResultado
import org.example.cliente.PedidoParaSair
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.collections.mutableMapOf



class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.go_campus/app"
    private var conexao: Socket? = null
    private var transmissor: ObjectOutputStream? = null
    private var receptor: ObjectInputStream? = null
    private var parceiro: Parceiro? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "enviarPedido") {
                val operacao = call.argument<String>("operacao")
                val colecao = call.argument<String>("colecao")
                val parametros = call.argument<Map<String, Any>>("parametros")

                executarPedido(operacao, colecao, parametros, result)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onStart() {
        super.onStart()
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val host = "10.0.2.2"
                val porta = 3000
                conexao = Socket(host, porta)
                println("Conectado ao servidor $host:$porta")
                transmissor = ObjectOutputStream(conexao?.getOutputStream())
                receptor = ObjectInputStream(conexao?.getInputStream())
                parceiro = Parceiro(conexao!!, receptor!!, transmissor!!)
                println("Conexão estabelecida e parceiro criado")
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    override fun onStop() {
        super.onStop()
        CoroutineScope(Dispatchers.IO).launch {
            try {
                parceiro?.receba(PedidoParaSair())
                println("Desconectado do servidor")
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun executarPedido(
        operacao: String?, 
        colecao: String?, 
        parametros: Map<String, Any>?,
        result: MethodChannel.Result
    ) {
        // Executando em uma coroutine
        CoroutineScope(Dispatchers.IO).launch {
            val resposta = mutableMapOf<String, Any>()

            try {
                // Enviar o pedido de operação
                val pedido = PedidoDeOperacao(operacao!!, colecao!!, parametros ?: emptyMap())
                println("Enviando pedido: $parametros")

                parceiro?.receba(pedido)
                // Receber a resposta do servidor
                parceiro?.receba(PedidoDeResultado())
                val resultado = parceiro?.envie()
                println("Recebido resultado: $resultado")

                // Tratando diferentes tipos de respostas
                when (resultado) {
                    is org.example.servidor.ComunicadoDeResultado -> {
                        resposta["status"] = "success"
                        resposta["message"] = resultado.toString()
                    }
                    is org.example.cliente.PedidoDeResultado -> {
                        resposta["status"] = "success"
                        resposta["message"] = resultado.toString()
                    }
                    else -> {
                        resposta["status"] = "error"
                        resposta["message"] = "Tipo de resposta desconhecido do servidor"
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                resposta["status"] = "error"
                resposta["message"] = e.message ?: "Erro desconhecido"
            }

            withContext(Dispatchers.Main) {
                result.success(resposta) // Envia o resultado para o Flutter
            }
        }
    }
}





