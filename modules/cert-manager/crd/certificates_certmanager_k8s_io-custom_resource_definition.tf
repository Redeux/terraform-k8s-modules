resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "certificates_certmanager_k8s_io" {
  metadata {
    name = "certificates.certmanager.k8s.io"
  }
  spec {

    additional_printer_columns {
      json_path = <<-EOF
        .status.conditions[?(@.type=="Ready")].status
        EOF
      name      = "Ready"
      type      = "string"
    }
    additional_printer_columns {
      json_path = ".spec.secretName"
      name      = "Secret"
      type      = "string"
    }
    additional_printer_columns {
      json_path = ".spec.issuerRef.name"
      name      = "Issuer"
      priority  = 1
      type      = "string"
    }
    additional_printer_columns {
      json_path = <<-EOF
        .status.conditions[?(@.type=="Ready")].message
        EOF
      name      = "Status"
      priority  = 1
      type      = "string"
    }
    additional_printer_columns {
      json_path   = ".metadata.creationTimestamp"
      description = "CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC."
      name        = "Age"
      type        = "date"
    }
    group = "certmanager.k8s.io"
    names {
      kind   = "Certificate"
      plural = "certificates"
      short_names = [
        "cert",
        "certs",
      ]
    }
    preserve_unknown_fields = false
    scope                   = "Namespaced"
    subresources {
    }
    validation {
      open_apiv3_schema = <<-JSON
        {
          "description": "Certificate is a type to represent a Certificate from ACME",
          "properties": {
            "apiVersion": {
              "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources",
              "type": "string"
            },
            "kind": {
              "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds",
              "type": "string"
            },
            "metadata": {
              "type": "object"
            },
            "spec": {
              "description": "CertificateSpec defines the desired state of Certificate",
              "properties": {
                "acme": {
                  "description": "ACME contains configuration specific to ACME Certificates. Notably, this contains details on how the domain names listed on this Certificate resource should be 'solved', i.e. mapping HTTP01 and DNS01 providers to DNS names.",
                  "properties": {
                    "config": {
                      "items": {
                        "description": "DomainSolverConfig contains solver configuration for a set of domains.",
                        "properties": {
                          "dns01": {
                            "description": "DNS01 contains DNS01 challenge solving configuration",
                            "properties": {
                              "provider": {
                                "description": "Provider is the name of the DNS01 challenge provider to use, as configure on the referenced Issuer or ClusterIssuer resource.",
                                "type": "string"
                              }
                            },
                            "required": [
                              "provider"
                            ],
                            "type": "object"
                          },
                          "domains": {
                            "description": "Domains is the list of domains that this SolverConfig applies to.",
                            "items": {
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "http01": {
                            "description": "HTTP01 contains HTTP01 challenge solving configuration",
                            "properties": {
                              "ingress": {
                                "description": "Ingress is the name of an Ingress resource that will be edited to include the ACME HTTP01 'well-known' challenge path in order to solve HTTP01 challenges. If this field is specified, 'ingressClass' **must not** be specified.",
                                "type": "string"
                              },
                              "ingressClass": {
                                "description": "IngressClass is the ingress class that should be set on new ingress resources that are created in order to solve HTTP01 challenges. This field should be used when using an ingress controller such as nginx, which 'flattens' ingress configuration instead of maintaining a 1:1 mapping between loadbalancer IP:ingress resources. If this field is not set, and 'ingress' is not set, then ingresses without an ingress class set will be created to solve HTTP01 challenges. If this field is specified, 'ingress' **must not** be specified.",
                                "type": "string"
                              }
                            },
                            "type": "object"
                          }
                        },
                        "required": [
                          "domains"
                        ],
                        "type": "object"
                      },
                      "type": "array"
                    }
                  },
                  "required": [
                    "config"
                  ],
                  "type": "object"
                },
                "commonName": {
                  "description": "CommonName is a common name to be used on the Certificate. If no CommonName is given, then the first entry in DNSNames is used as the CommonName. The CommonName should have a length of 64 characters or fewer to avoid generating invalid CSRs; in order to have longer domain names, set the CommonName (or first DNSNames entry) to have 64 characters or fewer, and then add the longer domain name to DNSNames.",
                  "type": "string"
                },
                "dnsNames": {
                  "description": "DNSNames is a list of subject alt names to be used on the Certificate. If no CommonName is given, then the first entry in DNSNames is used as the CommonName and must have a length of 64 characters or fewer.",
                  "items": {
                    "type": "string"
                  },
                  "type": "array"
                },
                "duration": {
                  "description": "Certificate default Duration",
                  "type": "string"
                },
                "ipAddresses": {
                  "description": "IPAddresses is a list of IP addresses to be used on the Certificate",
                  "items": {
                    "type": "string"
                  },
                  "type": "array"
                },
                "isCA": {
                  "description": "IsCA will mark this Certificate as valid for signing. This implies that the 'cert sign' usage is set",
                  "type": "boolean"
                },
                "issuerRef": {
                  "description": "IssuerRef is a reference to the issuer for this certificate. If the 'kind' field is not set, or set to 'Issuer', an Issuer resource with the given name in the same namespace as the Certificate will be used. If the 'kind' field is set to 'ClusterIssuer', a ClusterIssuer with the provided name will be used. The 'name' field in this stanza is required at all times.",
                  "properties": {
                    "group": {
                      "type": "string"
                    },
                    "kind": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    }
                  },
                  "required": [
                    "name"
                  ],
                  "type": "object"
                },
                "keyAlgorithm": {
                  "description": "KeyAlgorithm is the private key algorithm of the corresponding private key for this certificate. If provided, allowed values are either \"rsa\" or \"ecdsa\" If KeyAlgorithm is specified and KeySize is not provided, key size of 256 will be used for \"ecdsa\" key algorithm and key size of 2048 will be used for \"rsa\" key algorithm.",
                  "enum": [
                    "rsa",
                    "ecdsa"
                  ],
                  "type": "string"
                },
                "keyEncoding": {
                  "description": "KeyEncoding is the private key cryptography standards (PKCS) for this certificate's private key to be encoded in. If provided, allowed values are \"pkcs1\" and \"pkcs8\" standing for PKCS#1 and PKCS#8, respectively. If KeyEncoding is not specified, then PKCS#1 will be used by default.",
                  "enum": [
                    "pkcs1",
                    "pkcs8"
                  ],
                  "type": "string"
                },
                "keySize": {
                  "description": "KeySize is the key bit size of the corresponding private key for this certificate. If provided, value must be between 2048 and 8192 inclusive when KeyAlgorithm is empty or is set to \"rsa\", and value must be one of (256, 384, 521) when KeyAlgorithm is set to \"ecdsa\".",
                  "type": "integer"
                },
                "organization": {
                  "description": "Organization is the organization to be used on the Certificate",
                  "items": {
                    "type": "string"
                  },
                  "type": "array"
                },
                "renewBefore": {
                  "description": "Certificate renew before expiration duration",
                  "type": "string"
                },
                "secretName": {
                  "description": "SecretName is the name of the secret resource to store this secret in",
                  "type": "string"
                },
                "usages": {
                  "description": "Usages is the set of x509 actions that are enabled for a given key. Defaults are ('digital signature', 'key encipherment') if empty",
                  "items": {
                    "description": "KeyUsage specifies valid usage contexts for keys. See: https://tools.ietf.org/html/rfc5280#section-4.2.1.3      https://tools.ietf.org/html/rfc5280#section-4.2.1.12",
                    "enum": [
                      "signing",
                      "digital signature",
                      "content commitment",
                      "key encipherment",
                      "key agreement",
                      "data encipherment",
                      "cert sign",
                      "crl sign",
                      "encipher only",
                      "decipher only",
                      "any",
                      "server auth",
                      "client auth",
                      "code signing",
                      "email protection",
                      "s/mime",
                      "ipsec end system",
                      "ipsec tunnel",
                      "ipsec user",
                      "timestamping",
                      "ocsp signing",
                      "microsoft sgc",
                      "netscape sgc"
                    ],
                    "type": "string"
                  },
                  "type": "array"
                }
              },
              "required": [
                "issuerRef",
                "secretName"
              ],
              "type": "object"
            },
            "status": {
              "description": "CertificateStatus defines the observed state of Certificate",
              "properties": {
                "conditions": {
                  "items": {
                    "description": "CertificateCondition contains condition information for an Certificate.",
                    "properties": {
                      "lastTransitionTime": {
                        "description": "LastTransitionTime is the timestamp corresponding to the last status change of this condition.",
                        "format": "date-time",
                        "type": "string"
                      },
                      "message": {
                        "description": "Message is a human readable description of the details of the last transition, complementing reason.",
                        "type": "string"
                      },
                      "reason": {
                        "description": "Reason is a brief machine readable explanation for the condition's last transition.",
                        "type": "string"
                      },
                      "status": {
                        "description": "Status of the condition, one of ('True', 'False', 'Unknown').",
                        "enum": [
                          "True",
                          "False",
                          "Unknown"
                        ],
                        "type": "string"
                      },
                      "type": {
                        "description": "Type of the condition, currently ('Ready').",
                        "type": "string"
                      }
                    },
                    "required": [
                      "status",
                      "type"
                    ],
                    "type": "object"
                  },
                  "type": "array"
                },
                "lastFailureTime": {
                  "format": "date-time",
                  "type": "string"
                },
                "notAfter": {
                  "description": "The expiration time of the certificate stored in the secret named by this resource in spec.secretName.",
                  "format": "date-time",
                  "type": "string"
                }
              },
              "type": "object"
            }
          },
          "type": "object"
        }
        JSON
    }

    versions {
      name    = "v1alpha1"
      served  = true
      storage = true
    }
  }
}