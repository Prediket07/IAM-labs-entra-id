## 📁 LAB10 – Identity Lifecycle Automation (JML)

### 🔹 Overview
This lab demonstrates full Joiner-Mover-Leaver (JML) lifecycle automation using Microsoft Entra ID and Azure Automation Runbooks.

---

### 🔹 Joiner – User Provisioning
Created a runbook to:
- Provision new user accounts  
- Assign department and job title  
- Dynamically assign users to security groups  

✅ Example:
- User: Test User (Sales Department)  
- Group: GG-IT-Users  

---

### 🔹 Mover – Access Change
Created a runbook to:
- Update department and job title  
- Remove user from old group  
- Add user to new group  

✅ Example:
- Moved user  
- From: GG-IT-Users  
- To: GG-HR-Users  

---

### 🔹 Leaver – Offboarding
Created a runbook to:
- Disable user account  
- Remove access  
- Simulate secure termination  

✅ Example:
- Disabled: Test User  

---

### 🔹 Key IAM Concepts Practiced
- RBAC  
- Least Privilege  
- Identity Lifecycle Management  
- Automation & Orchestration  
- Access Governance  
