resource "k8s_config_istio_io_v1alpha2_instance" "tcpaccesslog" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "tcpaccesslog"
    namespace = var.namespace
  }
  spec = <<-JSON
    {
      "compiledTemplate": "logentry",
      "params": {
        "monitored_resource_type": "\"global\"",
        "severity": "\"Info\"",
        "timestamp": "context.time | timestamp(\"2017-01-01T00:00:00Z\")",
        "variables": {
          "connectionDuration": "connection.duration | \"0ms\"",
          "connectionEvent": "connection.event | \"\"",
          "connection_security_policy": "conditional((context.reporter.kind | \"inbound\") == \"outbound\", \"unknown\", conditional(connection.mtls | false, \"mutual_tls\", \"none\"))",
          "destinationApp": "destination.labels[\"app\"] | \"\"",
          "destinationIp": "destination.ip | ip(\"0.0.0.0\")",
          "destinationName": "destination.name | \"\"",
          "destinationNamespace": "destination.namespace | \"\"",
          "destinationOwner": "destination.owner | \"\"",
          "destinationPrincipal": "destination.principal | \"\"",
          "destinationServiceHost": "destination.service.host | \"\"",
          "destinationWorkload": "destination.workload.name | \"\"",
          "protocol": "context.protocol | \"tcp\"",
          "receivedBytes": "connection.received.bytes | 0",
          "reporter": "conditional((context.reporter.kind | \"inbound\") == \"outbound\", \"source\", \"destination\")",
          "requestedServerName": "connection.requested_server_name | \"\"",
          "responseFlags": "context.proxy_error_code | \"\"",
          "sentBytes": "connection.sent.bytes | 0",
          "sourceApp": "source.labels[\"app\"] | \"\"",
          "sourceIp": "source.ip | ip(\"0.0.0.0\")",
          "sourceName": "source.name | \"\"",
          "sourceNamespace": "source.namespace | \"\"",
          "sourceOwner": "source.owner | \"\"",
          "sourcePrincipal": "source.principal | \"\"",
          "sourceWorkload": "source.workload.name | \"\"",
          "totalReceivedBytes": "connection.received.bytes_total | 0",
          "totalSentBytes": "connection.sent.bytes_total | 0"
        }
      }
    }
    JSON
}