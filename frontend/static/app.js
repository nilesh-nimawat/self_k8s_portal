// API endpoints
const ENDPOINTS = {
  namespace: "/create-namespace",
  deployment: "/create-deployment",
  service: "/create-service",
  configmap: "/create-configmap",
  secret: "/create-secret"
};

// const API_BASE =
//   window.location.hostname === "localhost"
//     ? "http://localhost:5000/api"
//     : "http://backend-service:5000/api";


const API_BASE =
  window.location.hostname === "localhost"
    ? "http://localhost:5000/api"
    : "/api";


const resourceSelect = document.getElementById("resourceType");
const fieldsContainer = document.getElementById("fieldsContainer");
const toastWrap = document.getElementById("toastWrap");
const badge = document.getElementById("resourceBadge");

// When dropdown changes
resourceSelect.addEventListener("change", function () {
  const type = this.value;

  fieldsContainer.innerHTML = "";
  toastWrap.innerHTML = "";
  badge.textContent = type ? type.toUpperCase() : "SELECT TYPE";

  if (!type) return;

  // Show fields based on type
if (type === "namespace") {
  fieldsContainer.innerHTML = `
   
    <div class="form-group">
      <label>Namespace Name</label>
      <input id="ns_name" type="text" placeholder="my-app" />
    </div>

    <button class="btn-submit" onclick="submitResource('${type}')">
      Create Namespace
    </button>
  `;
}

if (type === "deployment") {
  fieldsContainer.innerHTML = `
 
    <div class="form-group">
      <label>Namespace</label>
      <input id="dep_ns" type="text" placeholder="default" />
    </div>

    <div class="form-group">
      <label>Deployment Name</label>
      <input id="dep_name" type="text" placeholder="my-deployment" />
    </div>

    <div class="form-group">
      <label>Label (app)</label>
      <input id="dep_label" type="text" placeholder="myapp" />
    </div>

    <div class="form-group">
      <label>Container Name</label>
      <input id="dep_container_name" type="text" placeholder="my-container" />
    </div>

    <div class="form-group">
      <label>Image</label>
      <input id="dep_image" type="text" placeholder="nginx:latest" />
    </div>

    <div class="form-group">
      <label>Replicas</label>
      <input id="dep_replicas" type="number" value="1" />
    </div>

    <div class="form-group">
      <label>Container Port</label>
      <input id="dep_port" type="number" placeholder="80" />
    </div>

    <button class="btn-submit" onclick="submitResource('${type}')">
      Create Deployment
    </button>
  `;
}

  if (type === "service") {
    fieldsContainer.innerHTML = `
      <div class="form-group">
        <label>Namespace</label>
        <input id="svc_ns" type="text" placeholder="default" />
      </div>
      <div class="form-group">
        <label>Service Name</label>
        <input id="svc_name" type="text" placeholder="my-service" />
      </div>
      <div class="form-group">
        <label>Port</label>
        <input id="svc_port" type="number" value="80" />
      </div>
      <div class="form-group">
        <label>Target Port</label>
        <input id="svc_tport" type="number" value="8080" />
      </div>
       <div class="form-group">
        <label>Label</label>
        <input id="svc_label" type="text" placeholder="enter label"/>
      </div>
      <div class="form-group">
        <label>Service Type</label>
        <select id="svc_type">
          <option>ClusterIP</option>
          <option>NodePort</option>
          <option>LoadBalancer</option>
        </select>
      </div>
      <button class="btn-submit" onclick="submitResource('${type}')">
        Create Service
      </button>
    `;
  }

  if (type === "configmap") {
    fieldsContainer.innerHTML = `
  
      <div class="form-group">
        <label>Namespace</label>
        <input id="cm_ns" type="text" placeholder="default" />
      </div>
      <div class="form-group">
        <label>Name</label>
        <input id="cm_name" type="text" placeholder="app-config" />
      </div>
      <div class="form-group">
        <label>Key</label>
        <input id="cm_key" type="text" placeholder="APP_ENV" />
      </div>
      <div class="form-group">
        <label>Value</label>
        <input id="cm_value" type="text" placeholder="production" />
      </div>
      <button class="btn-submit" onclick="submitResource('${type}')">
        Create ConfigMap
      </button>
    `;
  }

  if (type === "secret") {
    fieldsContainer.innerHTML = `
    <div class="form-group">
      <label>Username</label>
      <input id="username" type="text" placeholder="user-a" />
    </div>
      <div class="form-group">
        <label>Namespace</label>
        <input id="sec_ns" type="text" placeholder="default" />
      </div>
      <div class="form-group">
        <label>Name</label>
        <input id="sec_name" type="text" placeholder="db-secret" />
      </div>
      <div class="form-group">
        <label>Key</label>
        <input id="sec_key" type="text" placeholder="DB_PASSWORD" />
      </div>
      <div class="form-group">
        <label>Value</label>
        <input id="sec_value" type="password" />
      </div>
      <button class="btn-submit" onclick="submitResource('${type}')">
        Create Secret
      </button>
    `;
  }
});


// Submit function
async function submitResource(type) {

  let payload = {};

if (type === "namespace") {
  payload = {
    role: localStorage.getItem("k8sRole"),
    namespace: document.getElementById("ns_name").value
  };
}

if (type === "deployment") {
  payload = {
    role: localStorage.getItem("k8sRole"),
    namespace: document.getElementById("dep_ns").value,
    name: document.getElementById("dep_name").value,
    label: document.getElementById("dep_label").value,
    container_name: document.getElementById("dep_container_name").value,
    image: document.getElementById("dep_image").value,
    replicas: Number(document.getElementById("dep_replicas").value),
    port: Number(document.getElementById("dep_port").value)
  };
}

  if (type === "service") {
    payload = {
      role: localStorage.getItem("k8sRole"),
      namespace: document.getElementById("svc_ns").value,
      name: document.getElementById("svc_name").value,
      port: Number(document.getElementById("svc_port").value),
      targetPort: Number(document.getElementById("svc_tport").value),
      type: document.getElementById("svc_type").value,
      label: document.getElementById("svc_label").value
    };
  }

  if (type === "configmap") {
    
    payload = {
      role: localStorage.getItem("k8sRole"),
      username: document.getElementById("username").value,
      namespace: document.getElementById("cm_ns").value,
      name: document.getElementById("cm_name").value,
      key: document.getElementById("cm_key").value,
      value: document.getElementById("cm_value").value
    };
  }

  if (type === "secret") {
    payload = {
      role: localStorage.getItem("k8sRole"),
      namespace: document.getElementById("sec_ns").value,
      name: document.getElementById("sec_name").value,
      key: document.getElementById("sec_key").value,
      value: document.getElementById("sec_value").value
    };
  }

  try {
    const response = await fetch(API_BASE+ ENDPOINTS[type], {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });

    const result = await response.json();  
    console.log(result)

    if (response.ok) {
        showToast("success", result.message);
    } else {
        showToast("error",response.status + " : " + result.message  || "Something went wrong");
    }

   } catch (error) {
        showToast("error", "Backend connection failed", error);
    }
}




// Toast message
function showToast(type, message) {
  toastWrap.innerHTML = `
    <div class="toast ${type}">
      ${message}
    </div>
  `;
}




document.addEventListener("DOMContentLoaded", () => {

  const loginCard = document.getElementById("loginCard");
  const mainPortal = document.getElementById("mainPortal");
  const loginBtn = document.getElementById("loginBtn");
  const usernameInput = document.getElementById("username");
  const passwordInput = document.getElementById("password");
  const toastWrap = document.getElementById("toastWrap");

  // 🔥 Auto Login if token exists
  const existingToken = localStorage.getItem("k8sUser");
  if (existingToken) {
    loginCard.style.display = "none";
    mainPortal.style.display = "block";
    addLogoutButton();
  }

  // 🔐 Login
  loginBtn.addEventListener("click", async () => {
    const username = usernameInput.value.trim();
    const password = passwordInput.value.trim();

    if (!username || !password) {
      showToast("Username and Password required", "error");
      return;
    }

    try {
      loginBtn.disabled = true;
      loginBtn.innerText = "Logging in...";

      const response = await fetch(API_BASE + "/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, password })
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || "Login failed");
      }

      localStorage.setItem("k8sUser", data.username);
      localStorage.setItem("k8sRole", data.role);

      console.log(data)

      showToast("Login successful ✅", "success");

      loginCard.style.display = "none";
      mainPortal.style.display = "block";
      addLogoutButton();

    } catch (error) {
      showToast(error.message, "error");
    } finally {
      loginBtn.disabled = false;
      loginBtn.innerText = "Login";
    }
  });

  // 🔔 Toast
  function showToast(message, type) {
    const toast = document.createElement("div");
    toast.className = "toast " + type;
    toast.innerText = message;

    toastWrap.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
  }

  // 🔓 Logout
  function addLogoutButton() {
    if (document.getElementById("logoutBtn")) return;

    const logoutBtn = document.createElement("button");
    logoutBtn.innerText = "Logout";
    logoutBtn.id = "logoutBtn";
    logoutBtn.style.margin = "10px";

    logoutBtn.addEventListener("click", () => {
      localStorage.removeItem("k8sUser");
      localStorage.removeItem("k8sRole");

      mainPortal.style.display = "none";
      loginCard.style.display = "block";

      showToast("Logged out successfully", "success");
      logoutBtn.remove();
    });

    document.querySelector("header").appendChild(logoutBtn);
  }
});

