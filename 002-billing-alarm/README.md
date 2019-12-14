## Based on
* Udemy: AWS Certified Solutions Architect - Associate 2020
* [Lecture 9: Create a billing alarm](https://www.udemy.com/course/aws-certified-solutions-architect-associate/learn/lecture/13886250#overview)

## steps
1) Switch to N. Virginia
2) In
    > Cloudwatch
    > Billing
    > Create alarm (center bottom of screen not right top)
3) Configure conditions
    > Whenever EstimatedCharges is Greater than...: 10 USD 
    > Next
4) Configure action
    > Select an SNS topic: Create new topic
    > Create a new topic...: `Billing-alarm`
    > Email endpoints that will receive the notification...:
        `personal-email,work-email,partner-email`
    > Create topic
    > Next
5) Add a description
    > Define a unique name: BillingAlarm
    > Alarm description - optional: Send me an email if my AWS bill goes over 10$ for this month
    > Next
6) Preview and create
    > Create alarm