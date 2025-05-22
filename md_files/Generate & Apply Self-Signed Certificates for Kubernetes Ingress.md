# 🔐 Generate SSL/TLS Certificates (Self-Signed) for Kubernetes Ingress
- This guide helps you generate self-signed SSL/TLS certificates and use them in Kubernetes Ingress to enable HTTPS.

---

## 🛠️ Prerequisites

- OpenSSL installed
- Kubernetes cluster and `kubectl` configured
- Ingress controller (e.g., NGINX) deployed

---

## 🚀 Step-by-Step Guide

### ✅ Create an OpenSSL config file
- Create a file:
```bash
sudo vim openssl-san.cnf
```

- Copy below code:
```bash

[req]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
req_extensions     = req_ext

[dn]
C = IN
ST = State
L = City
O = MyOrg
OU = MyUnit
CN = userapp.<nginx_public-ip>.nip.io

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = userapp.<nginx_public-ip>.nip.io
```

### ✅ Generate the Private Key
- Run this command:
```bash
openssl genrsa -out userapp.key 2048
```

### ✅ Generate the Certificate Using the Config
- Run this command:
```bash
openssl req -x509 -new -nodes -key userapp.key -sha256 -days 365 \
-out userapp.crt -config openssl-san.cnf -extensions req_ext
```

#### 📁 Output
- userapp.crt → Certificate
- userapp.key → Private Key

---

## Use your self-signed certificate with a Kubernetes Ingress

### ✅ Create the TLS Secret

- Run this command:

```bash
kubectl create secret tls userapp-tls \
  --cert=userapp.crt \
  --key=userapp.key \
  --namespace=<namespace>
```

- Replace <namespace> with your actual namespace.
#### NOTE: You should create the TLS secret in the same namespace where your Ingress resource and application service are running.

### ✅ Define the Ingress Resource
- Example Ingress manifest that uses the TLS secret:

- Create ingress-resource definition file:
```bash
sudo vim  ingress-resource.yaml
```

- Copy below code:
```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: <ingress-resource name>
  namespace: <namespace>
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/proxy-body-size: "1024m"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "60s"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - <service_name>.<ingress_public-ip>.nip.io
    secretName: userapp-tls  # The name of the TLS secret you created
  rules:
  - host: <service_name>.<ingress_public-ip>.nip.io
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: <service_name>
            port:
              number: <port>
```

### ✅ Apply configuration
- Run below command:
```bash
kubectl apply -f ingress-resource.yaml
```

### ✅ Test it
- Browse it by making necessary changes:
```bash
<service_name>.<ingress_public-ip>.nip.io
```
---

### ✅ Issues: https with a strikethrough and "Not Secure"

- The https with a strikethrough and "Not Secure" message means your browser detects HTTPS is used but the certificate is not trusted (self-signed or invalid).

### ✅ This happens because:
- Your browser sees HTTPS is enabled.
- But it doesn't trust the certificate because it’s self-signed or missing from trusted cert authorities.

### ✅ How to make it show the normal HTTPS padlock (✅ secure) in a test environment?
- Add your self-signed certificate as a trusted root certificate on your local machine/browser.
- This tells your system to trust that cert explicitly, so no warning.

### ✅ Quick steps to trust your self-signed cert locally (example for Windows):
- Export your "userapp.crt" certificate file (in .crt or .cer format).
- Open Manage Computer Certificates (certmgr.msc).
- Navigate to Trusted Root Certification Authorities → Certificates.
- Right-click and select Import.
- Import your userapp.crt file.
- Restart your browser and try accessing the site again.

### Now access your application and it will work with "HTTPS".
