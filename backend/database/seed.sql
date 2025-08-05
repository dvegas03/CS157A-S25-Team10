DROP DATABASE IF EXISTS chefs_circle;
CREATE DATABASE IF NOT EXISTS chefs_circle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE chefs_circle;

CREATE USER IF NOT EXISTS 'chef'@'localhost' IDENTIFIED BY 'yourpassword';
GRANT ALL PRIVILEGES ON chefs_circle.* TO 'chef'@'localhost';
FLUSH PRIVILEGES;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS user_achievements;
DROP TABLE IF EXISTS user_progress;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS quizzes;
DROP TABLE IF EXISTS lesson_content;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS cuisines;
DROP TABLE IF EXISTS streak;
DROP TABLE IF EXISTS achievements;
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    pwd VARCHAR(255) NOT NULL,
    profile_image TEXT DEFAULT NULL,
    xp INT NOT NULL DEFAULT 0
);

-- Create cuisines table
CREATE TABLE cuisines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(10) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create skills table
CREATE TABLE skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cuisine_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    order_index INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cuisine_id) REFERENCES cuisines(id) ON DELETE CASCADE
);

-- Create lessons table
CREATE TABLE lessons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    skill_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    order_index INT NOT NULL,
    xp_reward INT DEFAULT 10,
    icon VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE
);

-- Create lesson_content table
CREATE TABLE lesson_content (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lesson_id INT NOT NULL,
    section_title VARCHAR(100) NOT NULL,
    content_text TEXT NOT NULL,
    picture_url VARCHAR(512) DEFAULT NULL,
    order_index INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

-- Create quizzes table
CREATE TABLE quizzes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lesson_id INT NOT NULL,
    question_text TEXT NOT NULL,
    correct_answer TEXT NOT NULL,
    wrong_answer_1 TEXT NOT NULL,
    wrong_answer_2 TEXT NOT NULL,
    wrong_answer_3 TEXT NOT NULL,
    explanation TEXT,
    order_index INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

-- Create user_progress table
CREATE TABLE user_progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    status ENUM('locked', 'available', 'completed') DEFAULT 'locked',
    completed_at TIMESTAMP NULL,
    score INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_lesson (user_id, lesson_id)
);

-- Create streak table
CREATE TABLE streak (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usr_id INT NOT NULL,
    curr_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    last_active_dt DATE,
    FOREIGN KEY (usr_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create achievements table
CREATE TABLE achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    icon VARCHAR(255)
);

-- Create user_achievements table
CREATE TABLE user_achievements (
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    PRIMARY KEY (user_id, achievement_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE
);


-- Insert sample users
INSERT INTO users (name, username, email, pwd, xp) VALUES
('Alice', 'alice_a', 'alice@example.com', 'password123', 0),
('Bob', 'bob_b', 'bob@example.com', 'securepass', 0),
('Charlie', 'charlie_c', 'charlie@example.com', 'mypassword', 0);

-- Insert sample cuisines
INSERT INTO cuisines (name, icon, description) VALUES
('Italian', 'it', 'Master the art of Italian cooking with pasta, pizza, and traditional dishes'),
('Japanese', 'jp', 'Discover the delicate art of Japanese cuisine with sushi, ramen, and traditional techniques'),
('Mexican', 'mx', 'Explore vibrant Mexican flavors with tacos, enchiladas, and authentic spices');

-- Insert skills for Italian cuisine
INSERT INTO skills (cuisine_id, name, description, order_index) VALUES
(1, 'Pasta Basics', 'Learn to make fresh pasta and master classic sauces', 1),
(1, 'Pizza Mastery', 'From dough to toppings, become a pizza expert', 2),
(1, 'Italian Sauces', 'Master the five mother sauces of Italian cuisine', 3),
(1, 'Desserts & Pastries', 'Sweet endings with tiramisu and cannoli', 4);






-- Insert lessons for Italian Pasta Basics
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(1, 'Fresh Pasta Dough', 'Learn to make authentic Italian pasta dough from scratch', 1, 10, '🍝'),
(1, 'Classic Marinara', 'Master the essential tomato sauce', 2, 10, '🥫'),
(1, 'Carbonara Sauce', 'Create the perfect creamy carbonara', 3, 15, '🥓'),
(1, 'Pesto Genovese', 'Make authentic basil pesto', 4, 15, '🌿');

-- Insert lessons for Italian Pizza Mastery
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(2, 'Pizza Dough', 'Learn to make perfect pizza dough', 1, 10, '🍕'),
(2, 'Margherita Pizza', 'Master the classic Margherita', 2, 15, '🍅'),
(2, 'Pizza Toppings', 'Learn proper topping techniques', 3, 10, '🧀'),
(2, 'Wood-Fired Techniques', 'Advanced pizza cooking methods', 4, 20, '🔥');

-- Insert lessons for Italian Sauces
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(3, 'Marinara Sauce', 'Master the classic tomato sauce', 1, 10, '🥫'),
(3, 'Alfredo Sauce', 'Create creamy Alfredo sauce', 2, 15, '🥛'),
(3, 'Pesto Sauce', 'Make fresh basil pesto', 3, 15, '🌿'),
(3, 'Arrabbiata Sauce', 'Spicy tomato sauce with chili', 4, 20, '🌶️');

-- Insert lessons for Desserts & Pastries
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(4, 'Tiramisu', 'Classic Italian coffee dessert', 1, 15, '☕'),
(4, 'Cannoli', 'Crispy pastry with sweet ricotta filling', 2, 15, '🍰'),
(4, 'Panna Cotta', 'Silky smooth vanilla custard', 3, 10, '🍮'),
(4, 'Gelato', 'Authentic Italian ice cream', 4, 20, '🍨');





-- Insert quizzes for Fresh Pasta Dough lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(1, 'What is the main ingredient in traditional Italian pasta dough?', 'Semolina flour', 'All-purpose flour', 'Bread flour', 'Cake flour', 'Semolina flour gives pasta its characteristic texture and golden color.', 1),
(1, 'What is the ideal ratio of flour to eggs for pasta dough?', '100g flour to 1 egg', '200g flour to 1 egg', '50g flour to 1 egg', '150g flour to 1 egg', 'The traditional ratio is 100g of flour per egg, which creates the perfect dough consistency.', 2),
(1, 'How long should you knead pasta dough?', '8-10 minutes', '2-3 minutes', '15-20 minutes', '5-6 minutes', 'Kneading for 8-10 minutes develops the gluten and creates a smooth, elastic dough.', 3),
(1, 'Why do you let pasta dough rest before rolling?', 'To allow gluten to relax', 'To make it easier to roll', 'To save time later', 'To make it taste better', 'Resting allows the gluten to relax, making the dough easier to roll out.', 4);

-- Insert lesson content for Fresh Pasta Dough
INSERT INTO lesson_content (lesson_id, section_title, content_text, picture_url, order_index) VALUES
(1, 'Introduction', 'Making fresh pasta dough is the foundation of Italian cooking. Unlike dried pasta, fresh pasta has a tender, delicate texture that elevates any sauce. The key is in the technique and the quality of ingredients.', NULL ,1),
(1, 'Ingredients', 'You''ll need: 2 cups (250g) of ''00'' flour or all-purpose flour, 3 large eggs, 1/2 teaspoon salt, and 1-2 tablespoons of water (if needed). The ''00'' flour is preferred as it''s finely milled and creates a smoother dough.', NULL, 2),
(1, 'Step 1: Mixing the Dough', 'On a clean work surface, create a mound with your flour and make a well in the center. Crack the eggs into the well and add the salt. Using a fork, gradually incorporate the flour from the edges into the eggs, working in a circular motion.', 'https://cdn.loveandlemons.com/wp-content/uploads/2020/04/IMG_27387-1024x1005.jpg' ,3),
(1, 'Step 2: Kneading', 'Once the mixture comes together, begin kneading with your hands. Knead for 8-10 minutes until the dough is smooth and elastic. The dough should feel firm but not dry. If it''s too dry, add a few drops of water.', 'https://cdn.loveandlemons.com/wp-content/uploads/2020/04/IMG_27411-1024x960.jpg', 4),
(1, 'Step 3: Resting', 'Wrap the dough in plastic wrap and let it rest at room temperature for 30 minutes. This allows the gluten to relax and makes the dough easier to roll out.', 'https://www.cravethegood.com/wp-content/uploads/2021/06/easy-pizza-dough-10-1024x1536.jpg', 5),
(1, 'Step 4: Rolling and Cutting', 'Divide the dough into quarters. Roll each piece into a thin sheet (about 1/8 inch thick) using a rolling pin or pasta machine. Cut into your desired shape - fettuccine, tagliatelle, or ravioli squares.', 'https://cdn.loveandlemons.com/wp-content/uploads/2020/04/how-to-make-homemade-pasta.jpg', 6),
(1, 'Cooking Tips', 'Fresh pasta cooks much faster than dried pasta - usually 2-3 minutes in boiling salted water. The pasta is done when it floats to the surface and is tender but still has a slight bite (al dente).', NULL, 7);

-- Insert lesson content for Classic Marinara
INSERT INTO lesson_content (lesson_id, section_title, content_text, picture_url, order_index) VALUES
(2, 'Introduction', 'Marinara sauce is the quintessential Italian tomato sauce - simple, flavorful, and versatile. This sauce forms the base for many Italian dishes and is perfect for pasta, pizza, and more.', NULL, 1),
(2, 'Ingredients', 'You''ll need: 2 cans (28 oz each) San Marzano tomatoes, 1/4 cup olive oil, 4 cloves garlic (minced), 1/2 cup fresh basil (torn), 1 teaspoon salt, 1/2 teaspoon black pepper, and 1/4 teaspoon red pepper flakes (optional).', NULL, 2),
(2, 'Step 1: Preparing the Tomatoes', 'Drain the tomatoes and crush them by hand or use a food processor for a smoother sauce. San Marzano tomatoes are preferred for their sweet, low-acid flavor, but any quality canned tomatoes will work.', 'https://www.yummymummykitchen.com/wp-content/uploads/2022/04/san-marzano-sauce-29-1536x1024.jpg', 3),
(2, 'Step 2: Sautéing the Garlic', 'Heat the olive oil in a large saucepan over medium heat. Add the minced garlic and sauté for 1-2 minutes until fragrant but not browned. Garlic burns easily, so keep a close eye on it.', 'https://www.yummymummykitchen.com/wp-content/uploads/2022/04/san-marzano-sauce-28-1536x1024.jpg', 4),
(2, 'Step 3: Adding Tomatoes', 'Add the crushed tomatoes to the pan and stir to combine with the garlic. Add the salt, pepper, and red pepper flakes. Bring the sauce to a simmer.','https://www.yummymummykitchen.com/wp-content/uploads/2022/04/san-marzano-sauce-27-1536x1024.jpg' , 5),
(2, 'Step 4: Simmering', 'Reduce the heat to low and simmer the sauce for 30-45 minutes, stirring occasionally. The sauce will thicken and the flavors will develop. Add the torn basil leaves in the last 5 minutes of cooking.','https://www.yummymummykitchen.com/wp-content/uploads/2022/04/san-marzano-sauce-26-1536x1024.jpg' , 6),
(2, 'Serving Tips', 'This sauce can be used immediately or stored in the refrigerator for up to 5 days. It also freezes well for up to 3 months. Serve over pasta, use as a pizza sauce, or as a base for other Italian dishes.', 'https://www.yummymummykitchen.com/wp-content/uploads/2022/04/san-marzano-sauce-16-1536x1024.jpg' ,7);

INSERT INTO lesson_content (lesson_id, section_title, content_text, picture_url, order_index) VALUES
(3, 'Ingredients', '100 g / 3.5 oz pancetta or guanciale, finely chopped; 80 g / 1/2 cup Parmesan cheese, or Pecorino Romano; 4 eggs, large; 450 g /1 lbs spaghetti; 1 garlic clove, peeled and crushed; 1 tbsp butter, optional; salt; black pepper', NULL, 1),
(3, 'Step 1: Cook the Spaghetti', 'Cook the spaghetti according to package instructions in a large pot filled with salted water.', 'https://vikalinka.com/wp-content/uploads/2016/04/IMG_3852-Edit-300x200.jpg', 2),
(3, 'Step 2: Cook Pancetta/Bacon', 'Cook the chopped pancetta or bacon in a large pan with 1 or 2 whole cloves of garlic and 1 tbsp of butter until the fat is rendered, then discard the garlic. If using bacon, discard all but 1–2 tablespoons of fat.', 'https://vikalinka.com/wp-content/uploads/2016/04/IMG_3869-Edit-300x200.jpg', 3),
(3, 'Step 3: Mix Eggs & Cheese', 'In a small bowl mix 1 whole egg and 3 egg yolks (reserve the whites for another use or freeze them) and freshly grated parmesan cheese until blended.', 'https://vikalinka.com/wp-content/uploads/2016/04/IMG_3835-Edit-300x200.jpg', 4),
(3, 'Step 4: Combine Pasta & Pancetta', 'Once the pasta is cooked, drain it while reserving 1/2 cup of pasta water. Add the pasta directly to the pan with pancetta and about half of the reserved pasta water. Stir to coat, then take off the heat.', 'https://vikalinka.com/wp-content/uploads/2016/04/IMG_3870-Edit-300x200.jpg', 5),
(3, 'Step 5: Make the Sauce', 'Pour the egg and Parmesan mixture into the spaghetti while tossing it with tongs the entire time. Toss quickly not to let the eggs curdle. Taste and season with more salt, pepper, and more grated parmesan if desired. Add more pasta water for a saucier texture.', 'https://vikalinka.com/wp-content/uploads/2016/04/IMG_3893-Edit-300x200.jpg', 6);

INSERT INTO lesson_content (lesson_id, section_title, content_text, picture_url, order_index) VALUES
(4, 'Ingredients', '2 medium cloves garlic (10g); 2 tbsp pine nuts (30g); 3 oz basil leaves (85g); coarse sea salt; 21g Parmigiano Reggiano; 21g Pecorino Fiore Sardo; 3/4 cup (175ml) extra-virgin olive oil', NULL, 1),
(4, 'Step 1: Pound Garlic', 'Using a marble mortar and wooden pestle, pound the garlic to a paste.', 'https://www.seriouseats.com/thmb/M5OofWsNAHHmD7JNISou90DCNIo=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2018__08__20180731-pesto-reshoot-vicky-wasik-1--d9531beee56443eab31ee8fad4a33ddb.jpg', 2),
(4, 'Step 2: Add Pine Nuts', 'Add pine nuts and crush with pestle until a sticky, slightly chunky beige paste forms.', 'https://www.seriouseats.com/thmb/_wdO4nYSrDHHXh7R_5IKs9vUsOY=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2018__08__20180706-pesto-vicky-wasik-garlic-pinenuts-2ba4788353884b96ba08615e6dccf57a.jpg', 3),
(4, 'Step 3: Add Basil', 'Add basil leaves a handful at a time with a pinch of salt, grinding until all leaves are crushed to fine bits.', 'https://www.seriouseats.com/thmb/w4cxWhC9KQbnzNbyDtZ_49ixfzI=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2018__08__20180706-pesto-vicky-wasik-adding-basil-307007a563144bfea367bca436f4fc45.jpg', 4),
(4, 'Step 4: Add Cheese & Olive Oil', 'Add both cheeses, then slowly drizzle in olive oil, working it into the pesto with the pestle until a creamy sauce forms.', 'https://www.seriouseats.com/thmb/mAWLK2d9WJvgP3NdLq44Q-x5Hps=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2018__08__20180731-pesto-reshoot-vicky-wasik-9--ba813f48407b4e58bf446d2f62415d7e.jpg', 5),
(4, 'Step 5: Serve or Store', 'Serve with pasta right away or cover with a thin layer of olive oil and refrigerate overnight.', 'https://www.seriouseats.com/thmb/Y6ocaQHGu7XqBjjRPmw5mCNMdmw=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2018__08__20180731-pesto-reshoot-vicky-wasik-11--1500x1125-da04608777e94d9c8d0c137bcb96b233.jpg', 6);

INSERT INTO lesson_content (lesson_id, section_title, content_text, picture_url, order_index) VALUES
(5, 'Ingredients', '¾ cup warm water; 1½ tsp sugar; 1 (¼-ounce) package active dry yeast; 2 cups all-purpose flour; 1 tsp sea salt; 1 tbsp + 1 tsp extra-virgin olive oil', NULL, 1),
(5, 'Step 1: Activate Yeast', 'In a small bowl, stir together the water, sugar, and yeast. Set aside for 5 minutes, until foamy.', 'https://joyfoodsunshine.com/wp-content/uploads/2018/09/how-to-make-pizza-dough-2-1.jpg', 2),
(5, 'Step 2: Knead Dough', 'Turn the dough out onto a lightly floured surface and gently knead into a smooth ball.', 'https://joyfoodsunshine.com/wp-content/uploads/2023/02/easy-homemade-pizza-dough-recipe-10.jpg', 3),
(5, 'Step 3: First Rise', 'Brush a large bowl with 1 tsp olive oil and place dough inside. Cover and let rise until doubled, about 1 hour.', 'https://joyfoodsunshine.com/wp-content/uploads/2018/09/how-to-make-pizza-dough-recipe-9.jpg', 4),
(5, 'Step 4: Shape Dough', 'Turn dough out onto a floured surface. Stretch to fit a 14-inch pizza pan or similar.', 'https://joyfoodsunshine.com/wp-content/uploads/2023/02/how-to-make-pizza-dough-9.jpg', 5),
(5, 'Step 5: Top and Bake', 'Top as desired and bake 10–13 min in a 500°F oven, until crust is browned.', 'https://joyfoodsunshine.com/wp-content/uploads/2023/02/how-to-make-pizza-dough-12-1097x1536.jpg', 6);

-- Insert quizzes for Classic Marinara lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(2, 'What type of tomatoes are preferred for marinara sauce?', 'San Marzano tomatoes', 'Cherry tomatoes', 'Roma tomatoes', 'Beefsteak tomatoes', 'San Marzano tomatoes from Italy are prized for their sweet, low-acid flavor.', 1),
(2, 'What herb is essential in marinara sauce?', 'Basil', 'Oregano', 'Thyme', 'Rosemary', 'Fresh basil adds the characteristic Italian flavor to marinara sauce.', 2),
(2, 'How long should you simmer marinara sauce?', '30-45 minutes', '10-15 minutes', '1-2 hours', '5-10 minutes', 'Simmering for 30-45 minutes allows flavors to develop and sauce to thicken properly.', 3),
(2, 'What should you do with garlic when making marinara?', 'Sauté until fragrant but not browned', 'Cook until dark brown', 'Add raw at the end', 'Skip garlic entirely', 'Garlic should be sautéed gently to release flavor without burning.', 4);

-- Insert quizzes for Carbonara Sauce lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(3, 'What meat is traditionally used in carbonara?', 'Pancetta or guanciale', 'Bacon', 'Sausage', 'Chicken', 'Pancetta or guanciale are the traditional Italian meats used in carbonara.', 1),
(3, 'Why do you reserve pasta water in carbonara?', 'To create a creamy sauce', 'To save water', 'To cool down the pasta', 'To wash dishes', 'The starchy pasta water helps create the creamy sauce texture.', 2),
(3, 'How should you cook the eggs in carbonara?', 'Gently with residual heat', 'Scramble them first', 'Boil them separately', 'Fry them hard', 'The residual heat from hot pasta gently cooks the eggs without scrambling them.', 3),
(3, 'What cheese is essential in carbonara?', 'Pecorino Romano', 'Mozzarella', 'Parmesan only', 'Cheddar', 'Pecorino Romano is the traditional cheese used in carbonara.', 4);

-- Insert quizzes for Pesto Genovese lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(4, 'What nuts are used in traditional pesto?', 'Pine nuts', 'Walnuts', 'Almonds', 'Cashews', 'Pine nuts are the traditional choice for authentic pesto Genovese.', 1),
(4, 'Why should basil be completely dry for pesto?', 'To prevent watery pesto', 'To make it taste better', 'To save time', 'To preserve color', 'Dry basil prevents the pesto from becoming watery.', 2),
(4, 'How should you add olive oil to pesto?', 'Slowly while processing', 'All at once', 'After processing', 'Skip olive oil', 'Adding oil slowly while processing creates the right emulsion.', 3),
(4, 'What cheese combination is traditional in pesto?', 'Parmigiano-Reggiano and Pecorino', 'Mozzarella only', 'Cheddar and Parmesan', 'No cheese', 'The traditional combination is Parmigiano-Reggiano and Pecorino Romano.', 4);

-- Insert quizzes for Pizza Dough lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(5, 'What type of flour is best for pizza dough?', '00 flour or bread flour', 'Cake flour', 'All-purpose flour', 'Whole wheat flour', '00 flour or bread flour has the right protein content for pizza dough.', 1),
(5, 'How long should pizza dough rise?', '1-2 hours at room temperature', '30 minutes', 'Overnight in refrigerator', 'No rising needed', '1-2 hours at room temperature allows proper fermentation.', 2),
(5, 'What temperature should pizza be cooked at?', '500-550°F (260-290°C)', '350°F (175°C)', '400°F (200°C)', '600°F (315°C)', 'High heat creates the perfect crispy crust and melted cheese.', 3),
(5, 'Why do you punch down pizza dough?', 'To release air and redistribute yeast', 'To make it thinner', 'To save time', 'To make it taste better', 'Punching down releases air bubbles and redistributes the yeast.', 4);

-- Insert quizzes for Margherita Pizza lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(6, 'What are the traditional toppings on a Margherita pizza?', 'Tomato sauce, mozzarella, basil', 'Pepperoni and cheese', 'Mushrooms and olives', 'Ham and pineapple', 'The Margherita represents the Italian flag colors: red, white, and green.', 1),
(6, 'What type of mozzarella is best for Margherita?', 'Fresh mozzarella', 'Shredded mozzarella', 'Processed cheese', 'Any cheese', 'Fresh mozzarella provides the best texture and flavor.', 2),
(6, 'When should you add basil to Margherita pizza?', 'After baking', 'Before baking', 'During baking', 'Never', 'Adding basil after baking preserves its fresh flavor and color.', 3),
(6, 'What does the Margherita pizza represent?', 'All of the above', 'Italian flag colors', 'Queen Margherita''s favorite', 'Traditional Italian ingredients', 'The Margherita represents the Italian flag and was named after Queen Margherita.', 4);

-- Insert quizzes for Pizza Toppings lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(7, 'What''s the golden rule for pizza toppings?', 'Less is more', 'More is better', 'Use expensive ingredients', 'Mix sweet and savory', 'Too many toppings can make the pizza soggy and overwhelming.', 1),
(7, 'How should you arrange toppings on pizza?', 'Evenly distributed', 'All in the center', 'Only on the edges', 'Randomly scattered', 'Even distribution ensures every slice has a good balance of toppings.', 2),
(7, 'What should you do with wet ingredients?', 'Drain them well', 'Add extra cheese', 'Skip them entirely', 'Add more sauce', 'Wet ingredients can make the pizza soggy, so drain them thoroughly.', 3),
(7, 'When should you add delicate toppings?', 'After baking', 'Before baking', 'During baking', 'Never', 'Delicate toppings like fresh herbs should be added after baking to preserve their flavor.', 4);

-- Insert quizzes for Wood-Fired Techniques lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(8, 'What temperature do wood-fired ovens reach?', '800-900°F (425-480°C)', '500°F (260°C)', '600°F (315°C)', '400°F (200°C)', 'Wood-fired ovens reach very high temperatures for authentic pizza cooking.', 1),
(8, 'How long does pizza cook in a wood-fired oven?', '60-90 seconds', '10-15 minutes', '5-7 minutes', '20-25 minutes', 'The high heat cooks pizza very quickly in wood-fired ovens.', 2),
(8, 'What wood is best for pizza ovens?', 'Hardwoods like oak or maple', 'Softwoods like pine', 'Any wood', 'No wood needed', 'Hardwoods burn hotter and longer, providing consistent heat.', 3),
(8, 'Why rotate pizza in a wood-fired oven?', 'For even cooking', 'To show off', 'To save time', 'It''s not necessary', 'Rotation ensures the pizza cooks evenly on all sides.', 4);

-- Insert quizzes for Marinara Sauce lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(9, 'What''s the difference between marinara and other tomato sauces?', 'It''s simpler and quicker', 'It has more ingredients', 'It''s always spicy', 'It''s always sweet', 'Marinara is a simple, quick-cooking sauce with minimal ingredients.', 1),
(9, 'How long should marinara sauce simmer?', '20-30 minutes', '2-3 hours', '5-10 minutes', 'Overnight', 'Marinara cooks quickly to preserve the bright, fresh tomato flavor.', 2),
(9, 'What gives marinara its bright flavor?', 'Fresh herbs and minimal cooking', 'Long cooking time', 'Lots of spices', 'Sugar', 'Minimal cooking and fresh herbs preserve the bright tomato flavor.', 3),
(9, 'When should you add herbs to marinara?', 'At the end of cooking', 'At the beginning', 'Never', 'After serving', 'Adding herbs at the end preserves their fresh flavor.', 4);

-- Insert quizzes for Alfredo Sauce lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(10, 'What is the base of Alfredo sauce?', 'Butter and cheese', 'Cream and flour', 'Olive oil', 'Milk', 'Traditional Alfredo sauce is made with butter and cheese, not cream.', 1),
(10, 'What cheese is essential in Alfredo sauce?', 'Parmigiano-Reggiano', 'Mozzarella', 'Cheddar', 'Blue cheese', 'Parmigiano-Reggiano provides the authentic flavor and texture.', 2),
(10, 'How should you add pasta water to Alfredo?', 'Gradually while stirring', 'All at once', 'Never add pasta water', 'After serving', 'Gradual addition while stirring creates the perfect creamy consistency.', 3),
(10, 'What makes Alfredo sauce creamy?', 'Emulsification of butter and cheese', 'Adding cream', 'Using flour', 'Adding milk', 'The emulsification of butter and cheese creates the creamy texture.', 4);

-- Insert quizzes for Pesto Sauce lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(11, 'What region of Italy is pesto from?', 'Liguria', 'Tuscany', 'Sicily', 'Veneto', 'Pesto Genovese originates from the Liguria region of Italy.', 1),
(11, 'What tool is traditional for making pesto?', 'Mortar and pestle', 'Food processor', 'Blender', 'Hand mixer', 'Traditional pesto is made with a mortar and pestle for the best texture.', 2),
(11, 'How should you store pesto?', 'Covered with olive oil', 'In water', 'In the freezer', 'In the sun', 'Covering with olive oil prevents oxidation and preserves the pesto.', 3),
(11, 'What gives pesto its vibrant green color?', 'Fresh basil', 'Food coloring', 'Spinach', 'Parsley', 'Fresh basil leaves give pesto its characteristic vibrant green color.', 4);

-- Insert quizzes for Arrabbiata Sauce lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(12, 'What does ''arrabbiata'' mean in Italian?', 'Angry', 'Spicy', 'Hot', 'Red', 'Arrabbiata means ''angry'' in Italian, referring to the spicy heat.', 1),
(12, 'What gives arrabbiata its heat?', 'Red chili peppers', 'Black pepper', 'Cayenne pepper', 'Jalapeños', 'Red chili peppers are the traditional source of heat in arrabbiata.', 2),
(12, 'How should you handle the chili in arrabbiata?', 'Sauté with garlic', 'Add raw', 'Skip it', 'Add at the end', 'Sautéing the chili with garlic releases its flavor and heat properly.', 3),
(12, 'What pasta is traditional with arrabbiata?', 'Penne', 'Spaghetti', 'Fettuccine', 'Any pasta', 'Penne is the traditional pasta shape served with arrabbiata sauce.', 4);

-- Insert quizzes for Tiramisu lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(13, 'What does ''tiramisu'' mean?', 'Pick me up', 'Coffee cake', 'Sweet dessert', 'Italian treat', 'Tiramisu means ''pick me up'' in Italian, referring to the coffee content.', 1),
(13, 'What type of coffee is used in tiramisu?', 'Espresso', 'Regular coffee', 'Decaf coffee', 'Instant coffee', 'Espresso provides the authentic Italian coffee flavor for tiramisu.', 2),
(13, 'What cheese is essential in tiramisu?', 'Mascarpone', 'Cream cheese', 'Ricotta', 'Cottage cheese', 'Mascarpone is the traditional Italian cheese used in tiramisu.', 3),
(13, 'How should you layer tiramisu?', 'Ladyfingers, coffee, mascarpone mixture', 'All mixed together', 'Randomly', 'Only mascarpone', 'Traditional layering: ladyfingers soaked in coffee, then mascarpone mixture.', 4);

-- Insert quizzes for Cannoli lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(14, 'What region of Italy are cannoli from?', 'Sicily', 'Tuscany', 'Lombardy', 'Veneto', 'Cannoli are a traditional Sicilian dessert.', 1),
(14, 'What is the shell of cannoli made from?', 'Fried pastry dough', 'Baked dough', 'Phyllo dough', 'Puff pastry', 'Cannoli shells are made from fried pastry dough.', 2),
(14, 'What cheese is used in cannoli filling?', 'Ricotta', 'Mascarpone', 'Cream cheese', 'Cottage cheese', 'Ricotta cheese is the traditional filling for cannoli.', 3),
(14, 'How should cannoli be filled?', 'Just before serving', 'Days in advance', 'While hot', 'Never', 'Cannoli should be filled just before serving to keep the shell crispy.', 4);

-- Insert quizzes for Panna Cotta lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(15, 'What does ''panna cotta'' mean?', 'Cooked cream', 'Sweet cream', 'Vanilla cream', 'Italian cream', 'Panna cotta means ''cooked cream'' in Italian.', 1),
(15, 'What thickens panna cotta?', 'Gelatin', 'Flour', 'Cornstarch', 'Eggs', 'Gelatin is the traditional thickener for panna cotta.', 2),
(15, 'How should you serve panna cotta?', 'Chilled', 'Warm', 'Hot', 'Frozen', 'Panna cotta is served chilled for the best texture and flavor.', 3),
(15, 'What is the texture of panna cotta?', 'Silky and smooth', 'Thick and heavy', 'Light and fluffy', 'Crunchy', 'Panna cotta has a silky, smooth texture when properly made.', 4);

-- Insert quizzes for Gelato lesson
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(16, 'What makes gelato different from ice cream?', 'Less fat and air', 'More sugar', 'Different flavors', 'Different colors', 'Gelato has less fat and air than ice cream, making it denser.', 1),
(16, 'What temperature is gelato served at?', 'Warmer than ice cream', 'Colder than ice cream', 'Same as ice cream', 'Frozen solid', 'Gelato is served at a warmer temperature than ice cream.', 2),
(16, 'What gives gelato its dense texture?', 'Less air churned in', 'More fat', 'More sugar', 'Different milk', 'Less air is churned into gelato, creating a denser texture.', 3),
(16, 'What is the traditional gelato flavor?', 'Fior di latte (milk)', 'Vanilla', 'Chocolate', 'Strawberry', 'Fior di latte (milk) is the traditional, pure gelato flavor.', 4);




-- Insert streak data
INSERT INTO streak (usr_id, curr_streak, longest_streak, last_active_dt) VALUES
(1, 5, 10, '2025-01-20'),
(2, 2, 4, '2025-01-19'),
(3, 0, 3, '2025-01-18');

-- Insert achievements data
INSERT INTO achievements (title, description, icon) VALUES
('Italian Novice', 'Your journey into Italian cuisine has begun! You''ve completed your first recipe.', '🇮🇹'),
('Italian Intermediate', 'You''re getting the hang of it! You''ve completed three Italian recipes.', '🇮🇹'),
('Italian Expert', 'Mamma mia! You''ve mastered the art of Italian cooking by completing all recipes.', '🇮🇹'),
('Japanese Novice', 'A new path unfolds. You''ve completed your first Japanese recipe.', '🇯🇵'),
('Japanese Intermediate', 'Your skills are sharpening. You''ve completed three Japanese recipes.', '🇯🇵'),
('Japanese Expert', 'You have achieved culinary harmony. You''ve mastered all Japanese recipes.', '🇯🇵'),
('Mexican Novice', '¡Qué bueno! You''ve cooked your first Mexican dish.', '🇲🇽'),
('Mexican Intermediate', 'You''re spicing things up! You''ve completed three Mexican recipes.', '🇲🇽'),
('Mexican Expert', 'You are a master of Mexican flavor! You''ve completed all Mexican recipes.', '🇲🇽');

-- for debug purposes
-- -- Insert user achievements data
-- INSERT INTO user_achievements (user_id, achievement_id) VALUES
-- -- Alice's achievements
-- (1, 1), -- Italian Novice
-- (1, 2), -- Italian Intermediate
-- (1, 4); -- Japanese Novice
