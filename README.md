# CS157A-S25-Team10

## Frontend Setup

### Prerequisites
1. Install **Node.js** version `22.17.0`.

### Run Locally
1. Navigate to the `frontend` directory.
2. Run `npm install` to install dependencies.
3. Run `npm run dev` to start the development server.

## MySQL Setup

### Prerequisites
1. Install MySQL and MySQL Workbench
2. Navigate to MySQL Workbench, and click on "open a SQL script file"
3. Select the `seed.sql` in the `database` directory
4. Run the query by clicking on the lightning bolt
5. Right click on the schema list and click "Refresh All" to see your changes

Your backend should now be connected to MySQL database.

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
1. `vim /opt/tomcat/conf/tomcat-users.xml`
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
2. Run `mvn clean package cargo:redeploy`

