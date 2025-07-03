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

### Hosting On Tomcat
1. Create a Tomcat Context Element to point your Tomcat install
to the directory

### On Linux: 
cd /opt/tomcat/conf/Catalina/localhost
sudo nano the-chefs-circle.xml

In this new file, add the following Context element, replacing the docBase with the actual path to your folder and path with your desired URL path.

<Context docBase="/home/your_username/your_folder_name" path="/myapp" />
sudo systemctl restart tomcat

On Windows:
cd C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf\Catalina\localhost

notepad the-chefs-circle.xml

In this new file, add the following Context element, replacing the docBase with the actual path to your folder and path with your desired URL path.

XML

<Context docBase="C:\Users\your_username\your_folder_name" path="/myapp"

net stop Tomcat9 && net start Tomcat9
