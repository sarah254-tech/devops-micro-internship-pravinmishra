# Assignment 09 — Kubernetes Services: LoadBalancer on AKS

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Deploy a healthy NGINX application to Azure Kubernetes Service (AKS), expose it publicly using a LoadBalancer Service, observe readiness behavior, and scale the application behind the same public endpoint.

---

# Task 1 — Create or Connect to an AKS Cluster

## Goal

Create a small AKS cluster for this lab, or connect to an existing approved AKS lab cluster.

### Evidence

#### Screenshot 1 — Output of `kubectl get nodes` showing ready AKS node(s)

<![Image1](screenshots/Assignment9_task1.png)>

### Notes

**1. Why does this lab use a cloud-capable Kubernetes environment such as AKS for the LoadBalancer Service?**
A LoadBalancer Service needs a cloud provider that can provision and manage an external load balancer. AKS integrates Kubernetes Services with Azure networking.

**2. What Azure resources can Kubernetes provision when a LoadBalancer Service is created?**

Azure can provision a public IP address and load-balancing infrastructure, along with related networking resources required by the AKS configuration.

**3. Why is it important to delete unused AKS resources after the lab?**

AKS clusters and associated infrastructure can incur ongoing costs. Cleaning up resources that are no longer needed helps avoid unnecessary charges.

---

# Task 2 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the LoadBalancer Service manifests.

### Evidence

#### Screenshot 2 — Terminal showing the output of `pwd` confirming that you are working inside `~/k8s-labs/services/loadbalancer`

<![Image2](screenshots/Assignment9_task2.png)>

### Notes

**1. Why is it useful to keep Kubernetes manifests organized in dedicated directories?**

Organized directories make it easier to manage, locate and maintain Kubernetes configuration files. They also help separate different projects and assignments, reducing confusion and making version control easier.

**2. What are the names of the main Deployment and LoadBalancer Service YAML files you will create in this assignment?**

`00-nginx-deploy.yaml` and `01-nginx-svc-loadbalancer.yaml`

---

# Task 3 — Deploy a Healthy NGINX Application

## Goal

Create a healthy NGINX Deployment with readiness and liveness probes.

### Evidence

#### Screenshot 3 — Completed `00-nginx-deploy.yaml` manifest

<![Image3](screenshots/Assignment9_task3a.png)>

---

#### Screenshot 4 — Output showing successful rollout and two ready NGINX Pods

<![Image4](screenshots/Assignment9_task3b.png)>

### Notes

**1. Why must Pods be ready before they should receive public traffic?**

Pods should be ready so that incoming requests reach application instances capable of responding successfully. Routing traffic to unready Pods can result in failed or interrupted requests.

**2. What is the role of the readiness probe in this Deployment?**

The readiness probe checks whether NGINX is ready to receive traffic. Kubernetes uses its result to determine whether the Pod should be included among the Service's ready backends.

**3. What is the role of the liveness probe in this Deployment?**

The liveness probe checks whether the NGINX container is functioning. If the check repeatedly fails, Kubernetes restarts the container.

---

# Task 4 — Create and Test the LoadBalancer Service

## Goal

Create a public LoadBalancer Service and verify that the NGINX application is reachable from the internet.

### Evidence

#### Screenshot 5 — Completed `01-nginx-svc-loadbalancer.yaml` manifest

<![Image5](screenshots/Assignment9_task4a.png)>

---

#### Screenshot 6 — Output showing the Service with an assigned EXTERNAL-IP

<![Image6](screenshots/Assignment9_task4b.png)>

---

#### Screenshot 7 — Successful curl output from the public IP

<![Image7](screenshots/Assignment9_task4c.png)>

### Notes

**1. What does `type: LoadBalancer` instruct AKS to do?**

It instructs Kubernetes to request an externally accessible load balancer from the Azure cloud provider and associate it with the Service.

**2. What public IP was assigned to your Service?**

4.152.64.123

**3. How does the public request eventually reach the NGINX Pods?**

The request reaches the Azure load-balancing infrastructure, is forwarded to the Kubernetes Service, and is routed to eligible NGINX Pod endpoints selected by the Service's app: nginx label selector.

**4. Why should you wait for EXTERNAL-IP before testing the Service?**

Azure needs time to provision and configure the public IP and load-balancing infrastructure. Testing before the IP is assigned cannot establish the intended public endpoint.

---

# Task 5 — Observe How Readiness Protects Public Traffic

## Goal

Intentionally break readiness and observe how Kubernetes excludes unready Pods from ready Service backends while existing healthy Pods continue serving public traffic.

### Evidence

#### Screenshot 8 — Completed `02-readiness-broken.yaml` patch file

<![Image8](screenshots/Assignment9_task5a.png)>

---

#### Screenshot 9 — Output showing the expected incomplete rollout or readiness failure

<![Image9](screenshots/Assignment9_task5b.png)>

---

#### Screenshot 10 — EndpointSlice output showing ready healthy backends and the effect of the readiness failure

<![Image10](screenshots/Assignment9_task5c.png)>

---

#### Screenshot 11 — Successful public curl response after recovery

<![Image11](screenshots/Assignment9_task5d.png)>

### Notes

**1. Why did the rollout not complete?**

The rollout did not complete because the new Pods failed their readiness probes. The probe requested a non-existent path and received HTTP 404, so Kubernetes did not consider the new Pods ready.

**2. Why can the public endpoint still work while new Pods fail readiness?**

The existing healthy Pods remain ready and continue serving requests. Kubernetes excludes the unready replacement Pods from normal Service traffic, allowing the public endpoint to continue working.

**3. What would happen if Kubernetes routed traffic to Pods before they were ready?**

Users could experience failed requests, errors or incomplete application responses because the application instances might not yet be able to serve traffic correctly.

**4. How did you restore the Deployment successfully?**

I reapplied the original NGINX Deployment manifest, restoring the readiness probe path to /. The replacement Pods passed their readiness checks, and the Deployment returned to two ready replicas.

---

# Task 6 — Scale the Deployment Behind the Load Balancer

## Goal

Scale the NGINX Deployment and confirm that more ready Pods become available behind the same public endpoint.

### Evidence

#### Screenshot 12 — Two ready NGINX Pods verified initially; four ready Pods verified after scaling

<![Image12](screenshots/Assignment9_task6a.png)>

---

#### Screenshot 13 — Successful public curl response after scaling

<![Image13](screenshots/Assignment9_task6b.png)>

### Notes

**1. What changed after scaling the Deployment from two to four replicas?**

The NGINX Deployment increased from two to four replicas. Kubernetes created two additional Pods, and all four became Ready.

**2. Did the public IP change after scaling? Explain why or why not.**

No. The LoadBalancer Service retained its public IP because the Service was not recreated.

**3. Why does scaling behind a LoadBalancer Service not require users to change the URL or IP they use?**

The Service maintains a set of ready backend endpoints and routes incoming traffic to eligible NGINX Pods. Scaling updates the available endpoints without changing the public entry point.

---

# Task 7 — Share Your LoadBalancer Lab on LinkedIn

## Goal

Share what you learned about exposing an NGINX application publicly through a LoadBalancer Service on AKS.

### Evidence

#### Screenshot 14 — Published LinkedIn post about your LoadBalancer lab on AKS

<![Image](screenshots/Assignment9_LinkedInPost.png)>

#### LinkedIn post link

https://www.linkedin.com/posts/sarah-w-amadi_devops-kubernetes-aks-share-7528433713089638400-ZJWv/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACAx4n8Bvuf305sZ28vfr5yvaoLLEr0SkSA

---

# Submission Instructions

- Include the completed YAML files:
  - `00-nginx-deploy.yaml`
  - `01-nginx-svc-loadbalancer.yaml`
  - `02-readiness-broken.yaml`
- Add all required screenshots, numbered 1–14, under their corresponding Evidence sections.
- Use clear, readable screenshots showing the relevant commands, configuration, and outputs.
- Ensure your full name is visible in the required screenshots.
- Complete the Notes for Tasks 1–6 in your own words.
- Capture all required evidence before cleaning up Azure resources.
- Plan or complete Azure cleanup according to your lab ownership and reuse arrangements.
- Do not expose passwords, tokens, private keys, cluster credentials, kubeconfig contents, subscription IDs, account IDs, or infrastructure details you are not permitted to share.

---

# Completion Checklist

- [ ] Created or connected to an approved AKS lab cluster
- [ ] Confirmed ready AKS node(s) (Screenshot 1)
- [ ] Created and entered the LoadBalancer lab directory (Screenshot 2)
- [ ] Created the NGINX Deployment manifest (Screenshot 3)
- [ ] Verified successful rollout and two ready NGINX Pods initially (Screenshot 4)
- [ ] Created the LoadBalancer Service manifest (Screenshot 5)
- [ ] Verified the assigned external IP (Screenshot 6)
- [ ] Verified successful public access using curl (Screenshot 7)
- [ ] Created the broken readiness patch (Screenshot 8)
- [ ] Observed the expected incomplete rollout or readiness failure (Screenshot 9)
- [ ] Inspected EndpointSlices during the readiness failure (Screenshot 10)
- [ ] Restored the healthy Deployment and verified public access (Screenshot 11)
- [ ] Scaled the Deployment to four ready Pods and verified updated Service backends (Screenshot 12)
- [ ] Verified public access after scaling (Screenshot 13)
- [ ] Completed the Notes for Tasks 1–6
- [ ] Published the LinkedIn post (Screenshot 14)
- [ ] Included all required YAML files and screenshots
- [ ] Planned or completed Azure cleanup
- [ ] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*
