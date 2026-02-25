from kubernetes import client, config
from kubernetes.client.exceptions import ApiException
import logging

logger = logging.getLogger(__name__)

# ---------------- CONFIG LOADING ---------------- #

try:
    config.load_incluster_config()
except:
    config.load_kube_config()

core_v1 = client.CoreV1Api()
apps_v1 = client.AppsV1Api()


# ---------------- NAMESPACE ---------------- #

def create_namespace_logic(namespace):
    try:
        core_v1.read_namespace(namespace)
        return {"message": f"Namespace '{namespace}' already exists"}, 409

    except ApiException as e:
        if e.status == 404:
            body = client.V1Namespace(
                metadata=client.V1ObjectMeta(name=namespace)
            )
            core_v1.create_namespace(body)
            return {"message": f"Namespace '{namespace}' created"}, 201

        logger.error(f"Namespace error: {e}")
        return {"error": str(e)}, 500


# ---------------- SERVICE ---------------- #

def create_service_logic(namespace, name, port, target_port, label, service_type):
    try:
        core_v1.read_namespaced_service(name, namespace)
        return {"message": "Service already exists"}, 409

    except ApiException as e:
        if e.status == 404:
            body = client.V1Service(
                metadata=client.V1ObjectMeta(name=name),
                spec=client.V1ServiceSpec(
                    selector={"app": label},
                    ports=[
                        client.V1ServicePort(
                            port=port,
                            target_port=target_port
                        )
                    ],
                    type=service_type
                )
            )

            core_v1.create_namespaced_service(namespace, body)
            return {"message": "Service created successfully"}, 201

        logger.error(f"Service error: {e}")
        return {"error": str(e)}, 500


# ---------------- DEPLOYMENT ---------------- #

def create_deployment_logic(namespace, name, container_name,
                            image, replicas, label, port):

    try:
        apps_v1.read_namespaced_deployment(name, namespace)
        return {"message": "Deployment already exists"}, 409

    except ApiException as e:
        if e.status == 404:
            body = client.V1Deployment(
                metadata=client.V1ObjectMeta(
                    name=name,
                    labels={"app": label}
                ),
                spec=client.V1DeploymentSpec(
                    replicas=replicas,
                    selector=client.V1LabelSelector(
                        match_labels={"app": label}
                    ),
                    template=client.V1PodTemplateSpec(
                        metadata=client.V1ObjectMeta(
                            labels={"app": label}
                        ),
                        spec=client.V1PodSpec(
                            containers=[
                                client.V1Container(
                                    name=container_name,
                                    image=image,
                                    ports=[
                                        client.V1ContainerPort(
                                            container_port=port
                                        )
                                    ]
                                )
                            ]
                        )
                    )
                )
            )

            apps_v1.create_namespaced_deployment(namespace, body)
            return {"message": "Deployment created successfully"}, 201

        logger.error(f"Deployment error: {e}")
        return {"error": str(e)}, 500


# ---------------- CONFIGMAP ---------------- #

def create_configmap_logic(namespace, name, key, value):
    try:
        core_v1.read_namespaced_config_map(name, namespace)
        return {"message": "ConfigMap already exists"}, 409

    except ApiException as e:
        if e.status == 404:
            body = client.V1ConfigMap(
                metadata=client.V1ObjectMeta(name=name),
                data={key: value}
            )

            core_v1.create_namespaced_config_map(namespace, body)
            return {"message": "ConfigMap created successfully"}, 201

        logger.error(f"ConfigMap error: {e}")
        return {"error": str(e)}, 500


# ---------------- SECRET ---------------- #

def create_secret_logic(namespace, name, key, value):
    try:
        core_v1.read_namespaced_secret(name, namespace)
        return {"message": "Secret already exists"}, 409

    except ApiException as e:
        if e.status == 404:
            body = client.V1Secret(
                metadata=client.V1ObjectMeta(name=name),
                type="Opaque",
                string_data={key: value}
            )

            core_v1.create_namespaced_secret(namespace, body)
            return {"message": "Secret created successfully"}, 201

        logger.error(f"Secret error: {e}")
        return {"error": str(e)}, 500