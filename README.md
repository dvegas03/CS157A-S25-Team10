# CS157A-S25-Team10

## Frontend Setup

### Prerequisites
1. Install **Node.js** version `22.17.0`.

### Run Locally
1. Navigate to the `frontend` directory.
2. Run `npm install` to install dependencies.
3. Run `npm run dev` to start the development server.

## Backend Setup

### Backend

### Run Locally
1. Install Java 21(JDK).
2. Install Maven.
3. Navigate to `backend` directory.
3. Run `mvn spring-boot:run` to start the backend.

### Hosting On Tomcat
Create a Tomcat user to deploy the backend

### On Linux: 
1. `cd /opt/tomcat/conf/tomcat-users.xml`
2. Add the following at the end of the file (before `</tomcat-users>` tag): 
`<role rolename="manager-script"/>`
`<user username="admin" password="yourpassword" roles="manager-script"/>`

### On Windows:
1. `cd C:\Program Files\Apache Software Foundation\Tomcat[...]\conf\Catalina\tomcat-users.xml`
2. Add the following at the end of the file (before `</tomcat-users>` tag): 
`<role rolename="manager-script"/>`
`<user username="admin" password="yourpassword" roles="manager-script"/>`

# To deploy:
1. Open the `/backend` folder of the project
2. Run `mvn package tomcat7:redeploy`

