from flask import Flask, request, jsonify
from flask_cors import CORS
from db import get_connection
import logging
from k8s import (
    create_namespace_logic,
    create_service_logic,
    create_deployment_logic,
    create_configmap_logic,
    create_secret_logic
)

app = Flask(__name__)
CORS(app, origins=["http://nilesh.appperfect.com"])

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(name)s - %(message)s"
)
logger = logging.getLogger(__name__)


# ---------------- LOGIN ---------------- #

@app.route("/api/login", methods=["POST"])
def login():
    data = request.get_json()

    if not data:
        return jsonify({"status": "error", "message": "Invalid request"}), 400

    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return jsonify({"status": "error", "message": "Username and password required"}), 400

    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT password, role FROM users WHERE username = %s", (username,))
        user = cur.fetchone()

        if not user or user[0] != password:
            return jsonify({"status": "failed", "message": "Invalid credentials"}), 401

        return jsonify({
            "status": "success",
            "username": username,
            "role": user[1]
        }), 200

    except Exception as e:
        logger.error(f"Login error: {e}")
        logger.info(e)
        return jsonify({"status": "error", "message": "Internal error"}), 500

    finally:
        if 'cur' in locals():
            cur.close()
        if 'conn' in locals():
            conn.close()


# ---------------- NAMESPACE ---------------- #

@app.route("/api/create-namespace", methods=["POST"])
def create_namespace():
    data = request.get_json()

    if not data:
        return jsonify({"message": "Invalid request"}), 400

    if data.get("role") != "namespace":
        return jsonify({"message": "Unauthorized"}), 403

    namespace = data.get("namespace")

    if not namespace:
        return jsonify({"message": "Namespace name required"}), 400

    return create_namespace_logic(namespace)


# ---------------- SERVICE ---------------- #

@app.route("/api/create-service", methods=["POST"])
def create_service():
    data = request.get_json()

    if not data:
        return jsonify({"message": "Invalid request"}), 400

    if data.get("role") != "services":
        return jsonify({"message": "Unauthorized"}), 403

    try:
        return create_service_logic(
            data.get("namespace"),
            data.get("name"),
            int(data.get("port")),
            int(data.get("targetPort")),
            data.get("label"),
            data.get("type")
        )
    except Exception as e:
        logger.error(f"Service creation error: {e}")
        return jsonify({"message": "Invalid input"}), 400


# ---------------- DEPLOYMENT ---------------- #

@app.route("/api/create-deployment", methods=["POST"])
def create_deployment():
    data = request.get_json()

    logger.info(f"Deployment request data: {data}")

    if not data:
        return jsonify({"message": "Invalid request"}), 400

    try:
        namespace = data.get("namespace")
        name = data.get("name")
        label = data.get("label")
        container_name = data.get("container_name")
        image = data.get("image")

        replicas = int(data.get("replicas") or 1)
        port = int(data.get("port") or 80)

        return create_deployment_logic(
            namespace,
            name,
            container_name,
            image,
            replicas,
            label,
            port
        )

    except Exception as e:
        logger.error(f"Deployment creation error: {e}", exc_info=True)
        return jsonify({"message": "Invalid input"}), 400


# ---------------- CONFIGMAP ---------------- #

@app.route("/api/create-configmap", methods=["POST"])
def create_configmap():
    data = request.get_json()

    logger.info(f"Incoming request data: {data}")
    if not data:
        return jsonify({"message": "Invalid request"}), 400

    if data.get("role") != "config_secret":
        return jsonify({"message": "Unauthorized"}), 403

    try:
        return create_configmap_logic(
            data.get("namespace"),
            data.get("name"),
            data.get("key"),
            data.get("value")
        )
    except Exception as e:
        logger.error(f"ConfigMap creation error: {e}")
        return jsonify({"message": "Invalid input"}), 400


# ---------------- SECRET ---------------- #

@app.route("/api/create-secret", methods=["POST"])
def create_secret():
    data = request.get_json()

    if not data:
        return jsonify({"message": "Invalid request"}), 400

    if data.get("role") != "secret":
        return jsonify({"message": "Unauthorized"}), 403

    try:
        return create_secret_logic(
            data.get("namespace"),
            data.get("name"),
            data.get("data")
        )
    except Exception as e:
        logger.error(f"Secret creation error: {e}")
        return jsonify({"message": "Invalid input"}), 400


# ---------------- MAIN ---------------- #
@app.route("/api")
def test():
    return "🔥 Flask app HTTPS ke peeche chal rahi hai!"

@app.route("/")
def entry():
    return "🔥 Flask app HTTPS ke peeche chal rahi hai!"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)