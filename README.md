
![Cloud](https://user-images.githubusercontent.com/36457009/228533629-a1fbe773-7706-4f53-b34d-d73ce10123e6.png)

Hello! 

Thank you for considering joining our team! 


We're a hosting company that offers cloud-based WordPress hosting services. As an SRE, you'll play an important role in alert handling, improving our monitoring system, incident response processes, and system stability, as well as optimizing performance. 

## Rules

We have three challenges for you to show off your analytic, debug and scripting skills.
You have to clone this repository to complete the following challenges in your own GitHub account.

Let's see what you got!


#### Where to start

- Make a clone of this repository to your Github account. 
- Solve the tasks.  
- Commit a document with your solutions.


#### Deliverability

Share the link to your repository with us.


## Task 1. Data stats

*NOTE: Go to `task-1` directory.*

You have a sample of webserver access logs in `access.log` file. Get the following information:

1) top 5 IP addresses requests come from;
2) number of requests with '500' and '200' HTTP codes;
3) number of requests per minute;
4) which domain is the most requested one?
5) do all the requests to '/page.php' result in '499' code?

Based on log and gathered data, can you outline any anomalies that should be taken into attention?

#### Desired Outcome

Create a `solution-1.md` file. It should include: results of gathered information; commands you use; your thoughts on the question. 

## Task 2. Debug

*NOTE: Go to `task-2` directory.*

Install any local K8s cluster (ex: Minikube) on your machine.
Use `nginx.yaml` to create resources of a simple webserver. Oops, looks like you need to fix some issues for application to run.
The success is to access Nginx page in browser.

### Desired outcome
Add working `nginx.yaml` file or update existing one with your fixes.
Create a `solution-2.md` file. Fill it with description of your findings, commands used during investigation. 

## Task 3. Let's do some scripting

*NOTE: Create `task-3` directoty.*

Develop a Bash script that checks the website’s load time via cURL and sends an alert if the load exceeds a certain threshold.

#### Instructions

- Write a Bash script that uses cURL to get website load time.
- Define a threshold value for the load, beyond which an alert should be sent.
- If the load exceeds the threshold, send a message to a Slack channel using cURL.
- Include comments in your code to explain how it works and how it should be configured.

#### Desired outcome

The Bash script you developed.

**Notes**: It is not needed to use a real Slack account/channel. You may use some fiction names.
You may adapt the script using different tooling and other languages if you feel it satisfies the task purpose better.
