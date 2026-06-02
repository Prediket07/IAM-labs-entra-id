Lab 17 – PIM for a Role with MFA and Approval Requirements

Objective
Configure Privileged Identity Management (PIM) for the Global Reader role to enforce just-in-time access with MFA and approval requirements before activation.

Environment
Tenant: BoclairIndustries (BoclairIndustries.onmicrosoft.com)
Admin: JairusRoss@boclairindustries.onmicrosoft.com

What Was Built

Configured PIM role settings for Global Reader with the following activation requirements:

	•	Maximum activation duration set to 1 hour
	•	Azure MFA required on activation
	•	Approval required to activate
	•	JairusRoss@boclairindustries.onmicrosoft.com set as approver
	•	Require justification on activation enabled

Created an eligible assignment:

	•	Member: Test Guest User (JairusrossIAM@gmail.com)
	•	Assignment type: Eligible
	•	Scope: Directory (Boclair Industries)
	•	Duration: Permanently eligible

Key Concepts Demonstrated

	•	PIM eligible vs active assignments
	•	Just-in-time access with time-bound activation
	•	MFA enforcement at role activation
	•	Approval workflow for privileged role access
	•	Least privilege through 1-hour maximum activation window
