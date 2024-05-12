
<pre>
Contact: Dean Cefola (deacef)
Updated: 2024-FEB-24
</pre>

Global Contact:  [Dean Cefola, Lea Gibson, Brandon Stephenson, Jonathan Core]

Audience: [FastTrack Customer PM]

Purpose:  [Guidance]

Last Major Update: 05/10/2024 [Charles - New scoping guidance, reformatting, and add new content]

# Azure Virtual Desktop Welcome Kit

## PM Scoping Questions

Each PM should copy and paste the below scoping questions into the description section of Ceres project or notes the when scoping an AVD project. If these notes are not in the Project when ready for an engineer, it would not be assigned.

These questions in the table below must be asked by the PM to the customer and the customer must have all these things ready when engaging with an engineer. Review a head of time with the Nominator so they can work with the customer if needed.

| Question | Yes | No | Guidance | Links |
|--|--|--|--|--|
| Does the customer have an active subscription?                      | [ ] | [ ]    | Customer should have an active subscription for their AVD workloads                                                                                                                | [Azure Subscription Creation](https://learn.microsoft.com/azure/cost-management-billing/manage/create-enterprise-subscription)          |
| Has the customer defined their Naming Convention?                   | [ ] | [ ]    | Customer should have their naming convention defined that follows Azure best practice                                                                                              | [Define your Naming Convention](https://learn.microsoft.com//azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) |
| Has the customer defined their tagging strategy?                    | [ ] | [ ]    | Customer should have their tagging strategy defined that follows Azure best practice                                                                                               | [Define your Tagging Strategy](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)  |
| Has the customer planned for their IP Address space?                | [ ] | [ ]    | Customer should know what IP Addresses they are going to use on their Virtual Networks                                                                                             | [Plan for IP Address](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing)     |
| Do they have the correct M365 licensing eligible for AVD?           | [ ] | [ ]    | Customer should have the M365 that can be used with Azure Virtual Desktop Operating Systems                                                                                        | [Licensing](https://learn.microsoft.com/azure/virtual-desktop/licensing)                                                                |
| Has the customer discussed which Use Cases they will start with?    | [ ] | [ ]    | Customer should have discussed internally what use cases they will start with during the engagement. It will help decide on what images to create first and what HostPools build.  | N/a                                                                                                                                     |
| Is the customer able to work on their deployment on their own time? | [ ] | [ ]    | We are not here to hand hold and the customer should be able to do work on their own with the guidance of the engineer.                                                            | N/A |

* Which Azure locations (Regions) are you planning to deploy to?

* Do you already have an Azure Landing Zone?

* What types of users do you plan to support with AVD and how many users?
  * [ ] Developers; #:
  * [ ] Remote workers; #:
  * [ ] Task workers; #:
  * [ ] Office Workers; #:
  * [ ] Power Users; #:
  * [ ] Graphic Designers; #:
  * [ ] Other (Define); #:

* How will your users connect to AVD?
  * [ ] Public Internet
  * [ ] Site-2-Site VPN
  * [ ] ExpressRoute

* What is your Identity Strategy?
  * [ ] Active Directory with Azure AD Connect in Azure  
  * [ ] Active Directory with Azure AD Connect On-Premises over VPN / ER
  * [ ] Active Directory Domain Services  

* Do you know what apps you want to use in AVD?
  * [ ] Office Pro Plus
  * [ ] TEAMS
  * [ ] Edge
  * [ ] OneDrive
  * [ ] AutoCAD
  * [ ] VSCode
  * [ ] Web Browser

* Does this project include any Citrix implementation? (Yes/No) - If yes, has Citrix Professional Services been engaged for the deployment?

* Does this project include any VMWare implementation? (Yes/No) If yes, has VMWare Professional Services been engaged for the deployment?

* What must be demonstrated with AVD to consider this project a success (choose all that apply)?

* What is your timeline for deployment of AVD?

## How to fill out Ceres Project

Project Description (Customer Example)
(Customer) has current Azure Landing Zone and would like to deploy an AVD production environment that can scale to 2,000 users. First phase of rollout is for 400 users in the US, and they will expand in the future globally to support the remaining users. The currently need support with architectural guidance around setup of the AVD environment, and assistance with operations and maintenance of their environment to include Image Management, Monitoring, Optimization and Scaling, and Profile Management.

Project CoS (Customer Example)
FTA to conduct an architecture review session with the customer to assess their proposed architecture and provide any best practices

FTA to conduct AVD Native engagements focused on operations and maintenance of their AVD environment with technical guidance and best practices:

Engagement 1: Image Management
Engagement 2: Monitoring
Engagement 3: Optimization and Scaling
Engagement 4: Profile Management

AVD environment deployed for 400 users in production by end of March

## Training Materials

|Item  |Purpose|Link  |Item Type  |
|--|--|--|--|
|AZ-140 AVD Certification Series | Training For every part of managing the AVD service for any size deployment | <https://aka.ms/AzureAcademy-AZ140> | Training
|Governance Training Video | Azure Academy | <http://tinyurl.com/AzureAcademy-Governance> | Training
|AVD Docs | This workbook focuses on the Reliability pillar of the Azure Well-Architected Framework  | <https://aka.ms/AVDDocs> |Training|
|Azure Virtual Desktop Architecture  | Microsoft Learn: Plan an Azure Virtual Desktop implementation series - AVD Architecture Introduction.  |<https://learn.microsoft.com/en-us/training/modules/azure-virtual-desktop-architecture/> |Training|
|Azure Virtual Desktop landing zone accelerator  | Microsoft Learn: The Azure Virtual Desktop landing zone accelerator is modular by design to let you customize environmental variables.  |<https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone#adopt-azure-virtual-desktop-landing-zone-accelerator>  |Training|
|Azure Landing Zone Checklist  |For existing Azure implementation

