Lab 18 – Access Package with Connected Organization and Lifecycle Policy

Objective
Configure an Entitlement Management access package for external partner access with lifecycle policy, access reviews, and approval workflow using a dedicated catalog.

Environment
Tenant: BoclairIndustries (BoclairIndustries.onmicrosoft.com)
Admin: JairusRoss@boclairindustries.onmicrosoft.com

What Was Built

Created a new catalog:

	•	Name: Boclair External Access
	•	Enabled for external users to request: Yes

Added resource to catalog:

	•	Security group added as available resource

Created access package:

	•	Name: Boclair External Partner Access
	•	Catalog: Boclair External Access
	•	Resource role: Security group, Member

Configured request policy:

	•	Who can request: Specific users and groups (Jairus Ross + Test Guest User)
	•	Who can request access: Self
	•	Require approval: Yes
	•	First approver: Jairus Ross
	•	Decision window: 14 days
	•	Require requestor justification: Yes

Configured requestor information:

	•	Custom question: “What is the name of your organization and the purpose of your access request?”
	•	Answer format: Short text

Configured lifecycle policy:

	•	Access expires: After 90 days
	•	Require access reviews: Yes
	•	Review frequency: Annually
	•	Reviewer: Jairus Ross
	•	If reviewers don’t respond: No change

Key Concepts Demonstrated

	•	Entitlement Management catalogs for organizing access packages
	•	Request-based time-limited external partner access
	•	Lifecycle policy with automatic expiration
	•	Access reviews for ongoing governance
	•	My Access portal link for self-service requests
	•	Approval workflow for controlled access provisioning

Note
Full external user approval workflow (For users not in your directory) requires Microsoft Entra ID Governance license add-on beyond M365 E5.
