DROP DATABASE IF EXISTS chefs_circle;
CREATE DATABASE IF NOT EXISTS chefs_circle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE chefs_circle;

CREATE USER IF NOT EXISTS 'chef'@'localhost' IDENTIFIED BY 'yourpassword';
GRANT ALL PRIVILEGES ON chefs_circle.* TO 'chef'@'localhost';
FLUSH PRIVILEGES;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS user_achievements;
DROP TABLE IF EXISTS user_progress;
DROP TABLE IF EXISTS user_favorite_cuisines;
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
    xp INT NOT NULL DEFAULT 0,
    is_admin TINYINT(1) NOT NULL DEFAULT 0
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

-- Create user_favorite_cuisines table
CREATE TABLE user_favorite_cuisines (
    user_id INT NOT NULL,
    cuisine_id INT NOT NULL,
    PRIMARY KEY (user_id, cuisine_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (cuisine_id) REFERENCES cuisines(id) ON DELETE CASCADE
);


-- Insert sample users
INSERT INTO users (name, username, email, pwd, xp, is_admin) VALUES
('Alice', 'alice_a', 'alice@example.com', 'password123', 0, 1),
('Bob', 'bob_b', 'bob@example.com', 'securepass', 0, 0),
('Charlie', 'charlie_c', 'charlie@example.com', 'mypassword', 0, 0);

INSERT INTO users (name, username, email, pwd, xp, is_admin) VALUES
('Diana',  'diana_d',  'diana@example.com',  'passdiana',  20, 0),
('Ethan',  'ethan_e',  'ethan@example.com',  'passethan',  30, 0),
('Fiona',  'fiona_f',  'fiona@example.com',  'passfiona',  10, 0),
('George', 'george_g', 'george@example.com', 'passgeorge', 15, 0),
('Hannah', 'hannah_h', 'hannah@example.com', 'passhannah', 25, 0),
('Isaac',  'isaac_i',  'isaac@example.com',  'passisaac',  5,  0),
('Julia',  'julia_j',  'julia@example.com',  'passjulia',  0,  0),
('Kevin',  'kevin_k',  'kevin@example.com',  'passkevin',  18, 0),
('Luna',   'luna_l',   'luna@example.com',   'passluna',   12, 0),
('Mason',  'mason_m',  'mason@example.com',  'passmason',  40, 0);

-- Insert sample cuisines
INSERT INTO cuisines (name, icon, description) VALUES
('Italian', 'it', 'Master the art of Italian cooking with pasta, pizza, and traditional dishes'),
('Japanese', 'jp', 'Discover the delicate art of Japanese cuisine with sushi, ramen, and traditional techniques'),
('Mexican', 'mx', 'Explore vibrant Mexican flavors with tacos, enchiladas, and authentic spices');

INSERT INTO cuisines (name, icon, description) VALUES
('French', 'fr', 'Explore classic French techniques from sauces to pastries'),
('Chinese', 'cn', 'Discover diverse regional Chinese dishes and stir-fry mastery'),
('Indian', 'in', 'Vibrant spices and curries from across India'),
('Thai', 'th', 'Bold Thai flavors with balance of sweet, sour, salty, and spicy'),
('Spanish', 'es', 'Spanish tapas, paella, and regional specialties'),
('Greek', 'gr', 'Mediterranean flavors with fresh herbs, olive oil, and cheeses'),
('Korean', 'kr', 'Korean BBQ, stews, and fermented specialties like kimchi');

-- Insert skills for Italian cuisine
INSERT INTO skills (cuisine_id, name, description, order_index) VALUES
(1, 'Pasta Basics', 'Learn to make fresh pasta and master classic sauces', 1),
(1, 'Pizza Mastery', 'From dough to toppings, become a pizza expert', 2),
(1, 'Italian Sauces', 'Master the five mother sauces of Italian cuisine', 3),
(1, 'Desserts & Pastries', 'Sweet endings with tiramisu and cannoli', 4);

INSERT INTO skills (cuisine_id, name, description, order_index) VALUES
(1, 'Bread & Baked Goods', 'Focaccia, ciabatta, and rustic loaves', 5),
(1, 'Regional (Northern Italy)', 'Risotto, polenta, and alpine specialties', 6),
(1, 'Regional (Southern Italy)', 'Tomato-forward, olive oil-rich dishes', 7),
(1, 'Antipasti & Salads', 'Bruschetta, caprese, and composed salads', 8),
(1, 'Seafood & Fish', 'Coastal seafood cookery and fish techniques', 9),
(1, 'Risotto & Grains', 'Creamy risotto and Italian grain cookery', 10);

-- Lessons for Italian Cuisine
-- Pasta Basics (skill_id = 1)
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(1, 'Fresh Pasta Dough', 'Learn to make authentic Italian pasta dough from scratch', 1, 10, '🍝'),
(1, 'Classic Marinara', 'Master the essential tomato sauce', 2, 10, '🥫'),
(1, 'Carbonara Sauce', 'Create the perfect creamy carbonara', 3, 15, '🥓'),
(1, 'Pesto Genovese', 'Make authentic basil pesto', 4, 15, '🌿'),
(1, 'Bolognese Sauce', 'Slow-simmered meat sauce fundamentals', 5, 15, '🥩'),
(1, 'Ravioli Basics', 'Sheeting, filling, and sealing ravioli', 6, 15, '🥟'),
(1, 'Lasagna Sheets & Assembly', 'Hand-rolled sheets and layered assembly', 7, 15, '🧀'),
(1, 'Gnocchi from Scratch', 'Potato gnocchi mixing and rolling', 8, 15, '🥔'),
(1, 'Cacio e Pepe', 'Pecorino and pepper emulsion technique', 9, 10, '🧂'),
(1, 'Tortellini Shaping', 'Folding and shaping techniques', 10, 15, '🥟');

-- Pizza Mastery (skill_id = 2)
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(2, 'Pizza Dough', 'Learn to make perfect pizza dough', 1, 10, '🍕'),
(2, 'Margherita Pizza', 'Master the classic Margherita', 2, 15, '🍅'),
(2, 'Pizza Toppings', 'Learn proper topping techniques', 3, 10, '🧀'),
(2, 'Wood-Fired Techniques', 'Advanced pizza cooking methods', 4, 20, '🔥'),
(2, 'Neapolitan Style', 'High-heat, classic Neapolitan method', 5, 15, '🍕'),
(2, 'New York Style', 'Long-ferment, foldable slice technique', 6, 15, '🗽'),
(2, 'Sicilian Pan Pizza', 'Thick, airy pan-baked pizza', 7, 15, '🍞'),
(2, 'Calzone & Stromboli', 'Folding, sealing, and baking filled doughs', 8, 15, '🥟'),
(2, 'Sauce & Cheese Mastery', 'Balancing moisture and melt', 9, 10, '🧀'),
(2, 'Advanced Fermentation', 'Poolish, biga, and cold ferment control', 10, 20, '⏱️');

-- Italian Sauces (skill_id = 3)
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(3, 'Marinara Sauce', 'Master the classic tomato sauce', 1, 10, '🥫'),
(3, 'Alfredo Sauce', 'Create creamy Alfredo sauce', 2, 15, '🥛'),
(3, 'Pesto Sauce', 'Make fresh basil pesto', 3, 15, '🌿'),
(3, 'Arrabbiata Sauce', 'Spicy tomato sauce with chili', 4, 20, '🌶️'),
(3, 'Bolognese (Ragù)', 'Classic ragù alla bolognese technique', 5, 15, '🥩'),
(3, 'Amatriciana', 'Guanciale, tomato, and pecorino sauce', 6, 15, '🥓'),
(3, 'Puttanesca', 'Tomato, olives, capers, anchovy sauce', 7, 15, '🫒'),
(3, 'Béchamel', 'Silky white sauce technique', 8, 10, '🥛'),
(3, 'Vodka Sauce', 'Tomato-cream emulsion with vodka', 9, 15, '🍸'),
(3, 'Mushroom Sauce', 'Savory sugo di funghi', 10, 15, '🍄');

-- Desserts & Pastries (skill_id = 4)
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(4, 'Tiramisu', 'Classic Italian coffee dessert', 1, 15, '☕'),
(4, 'Cannoli', 'Crispy pastry with sweet ricotta filling', 2, 15, '🍰'),
(4, 'Panna Cotta', 'Silky smooth vanilla custard', 3, 10, '🍮'),
(4, 'Gelato', 'Authentic Italian ice cream', 4, 20, '🍨'),
(4, 'Zabaglione', 'Foamy custard over bain-marie', 5, 10, '🥚'),
(4, 'Biscotti', 'Twice-baked cookies for perfect crunch', 6, 10, '🍪'),
(4, 'Pizzelle', 'Crisp anise waffle cookies', 7, 10, '🧇'),
(4, 'Sfogliatelle', 'Laminated shells with ricotta filling', 8, 20, '🥐'),
(4, 'Panettone Basics', 'Enriched dough mixing and proofing', 9, 20, '🍞'),
(4, 'Zeppole', 'Fried dough puffs and fillings', 10, 15, '🍩');

-- Bread & Baked Goods (skill_id = 5)
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(5, 'Focaccia', 'Olive oil-rich flatbread with airy crumb', 1, 10, '🫓'),
(5, 'Ciabatta', 'High-hydration loaf with open crumb', 2, 15, '🥖'),
(5, 'Pane Rustico', 'Country-style crusty Italian bread', 3, 10, '🍞'),
(5, 'Grissini', 'Thin, crispy breadsticks', 4, 10, '🥨'),
(5, 'Schiacciata', 'Tuscan-style flatbread', 5, 10, '🫓'),
(5, 'Pizza Bianca', 'Roman white pizza, olive oil and salt', 6, 15, '🍕'),
(5, 'Cornetti', 'Italian crescent pastries', 7, 15, '🥐'),
(5, 'Filone Shaping', 'Italian loaf shaping techniques', 8, 10, '🔪'),
(5, 'Biga Preferment', 'Preferment for flavor and structure', 9, 15, '⏱️'),
(5, 'Pane Toscano', 'Saltless Tuscan bread basics', 10, 15, '🍞');

-- Regional (Northern Italy) (skill_id = 6)
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(6, 'Risotto alla Milanese', 'Saffron risotto, classic technique', 1, 15, '🧂'),
(6, 'Risotto ai Funghi', 'Mushroom risotto with porcini', 2, 15, '🍄'),
(6, 'Polenta Basics', 'Creamy polenta foundations', 3, 10, '🌽'),
(6, 'Polenta Integrale', 'Whole-grain polenta variation', 4, 10, '🌾'),
(6, 'Vitello Tonnato', 'Veal with tuna-caper sauce', 5, 15, '🥩'),
(6, 'Bagna Cauda', 'Warm anchovy-garlic dip', 6, 10, '🫕'),
(6, 'Pizzoccheri', 'Buckwheat pasta with cabbage and cheese', 7, 15, '🥬'),
(6, 'Canederli', 'Bread dumplings, alpine style', 8, 10, '🥟'),
(6, 'Spezzatino', 'Northern-style beef stew', 9, 15, '🥘'),
(6, 'Bollito Misto', 'Assorted boiled meats with sauces', 10, 20, '🍖');

-- Regional (Southern Italy) (skill_id = 7)
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(7, 'Orecchiette e Cime di Rapa', 'Pugliese pasta with broccoli rabe', 1, 15, '🌿'),
(7, 'Caponata', 'Sweet-sour Sicilian eggplant', 2, 10, '🍆'),
(7, 'Arancini', 'Crispy stuffed rice balls', 3, 15, '🍙'),
(7, 'Pasta alla Norma', 'Tomato, eggplant, ricotta salata', 4, 15, '🍝'),
(7, 'Sugo al Tonno', 'Quick tuna tomato sauce', 5, 10, '🐟'),
(7, 'Frittura di Paranza', 'Mixed small-fish fry', 6, 15, '🍤'),
(7, 'Parmigiana di Melanzane', 'Layered eggplant casserole', 7, 15, '🧀'),
(7, 'Sarde a Beccafico', 'Stuffed sardines', 8, 15, '🐟'),
(7, 'Taralli', 'Crunchy ring-shaped snacks', 9, 10, '🫧'),
(7, 'Granita & Brioche', 'Icy dessert with soft brioche', 10, 10, '🍧');

-- Antipasti & Salads (skill_id = 8)
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(8, 'Bruschetta al Pomodoro', 'Tomato-garlic basil toasts', 1, 10, '🍅'),
(8, 'Insalata Caprese', 'Tomato, mozzarella, basil salad', 2, 10, '🥗'),
(8, 'Carpaccio', 'Raw beef slices with dressing', 3, 15, '🔪'),
(8, 'Insalata Tricolore', 'Arugula, radicchio, endive', 4, 10, '🥗'),
(8, 'Prosciutto e Melone', 'Cured ham and melon pairing', 5, 10, '🍈'),
(8, 'Crostini Toscani', 'Chicken liver pâté toasts', 6, 15, '🍞'),
(8, 'Insalata di Mare', 'Seafood salad', 7, 15, '🦐'),
(8, 'Giardiniera', 'Pickled vegetable relish', 8, 10, '🥕'),
(8, 'Panzanella', 'Tuscan bread salad', 9, 10, '🥖'),
(8, 'Antipasto Misto', 'Mixed antipasti platter', 10, 15, '🧀');

-- Seafood & Fish (skill_id = 9)
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(9, 'Spaghetti alle Vongole', 'Clam pasta with garlic and white wine', 1, 15, '🍝'),
(9, 'Pesce all\'Acqua Pazza', 'Poached fish with tomatoes and herbs', 2, 15, '🐟'),
(9, 'Salt-Baked Branzino', 'Whole fish baked in salt crust', 3, 20, '🧂'),
(9, 'Fritto Misto', 'Mixed fried seafood platter', 4, 15, '🍤'),
(9, 'Cacciucco', 'Tuscan fish stew', 5, 20, '🍲'),
(9, 'Tonno Scottato', 'Seared tuna with citrus', 6, 15, '🐟'),
(9, 'Polpo alla Luciana', 'Slow-cooked octopus', 7, 20, '🐙'),
(9, 'Baccalà Mantecato', 'Whipped salt cod spread', 8, 15, '🧄'),
(9, 'Calamari Ripieni', 'Stuffed squid in tomato sauce', 9, 15, '🦑'),
(9, 'Zuppa di Pesce', 'Hearty seafood soup', 10, 20, '🍜');

-- Risotto & Grains (skill_id = 10)
INSERT INTO lessons (skill_id, name, description, order_index, xp_reward, icon) VALUES
(10, 'Risotto Base Technique', 'Foundations of creamy risotto', 1, 15, '🍚'), 
(10, 'Risotto al Limone', 'Lemon-scented risotto', 2, 10, '🍋'),
(10, 'Risotto ai Porcini', 'Porcini mushroom risotto', 3, 15, '🍄'),
(10, 'Risotto al Nero di Seppia', 'Squid ink risotto', 4, 20, '🦑'),
(10, 'Farro Salad', 'Herby farro grain salad', 5, 10, '🌿'),
(10, 'Orzotto', 'Barley “risotto” technique', 6, 15, '🌾'),
(10, 'Risotto alle Verdure', 'Seasonal vegetable risotto', 7, 10, '🥕'),
(10, 'Risotto al Radicchio', 'Radicchio and red wine risotto', 8, 15, '🍷'),
(10, 'Farrotto ai Funghi', 'Farro “risotto” with mushrooms', 9, 15, '🍄'),
(10, 'Risotto Finishing', 'Mantecatura and plating', 10, 10, '🧈');

-- Lesson Content for Fresh Pasta Dough (lesson_id = 1)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(1, 'Introduction', 'Making fresh pasta dough is the foundation of Italian cooking. Unlike dried pasta, fresh pasta has a tender, delicate texture that elevates any sauce. The key is in the technique and the quality of ingredients.', 1),
(1, 'Ingredients', 'You''ll need: 2 cups (250g) of ''00'' flour or all-purpose flour, 3 large eggs, 1/2 teaspoon salt, and 1-2 tablespoons of water (if needed). The ''00'' flour is preferred as it''s finely milled and creates a smoother dough.', 2),
(1, 'Step 1: Mixing the Dough', 'On a clean work surface, create a mound with your flour and make a well in the center. Crack the eggs into the well and add the salt. Using a fork, gradually incorporate the flour from the edges into the eggs, working in a circular motion.', 3),
(1, 'Step 2: Kneading', 'Once the mixture comes together, begin kneading with your hands. Knead for 8-10 minutes until the dough is smooth and elastic. The dough should feel firm but not dry. If it''s too dry, add a few drops of water.', 4),
(1, 'Step 3: Resting', 'Wrap the dough in plastic wrap and let it rest at room temperature for 30 minutes. This allows the gluten to relax and makes the dough easier to roll out.', 5),
(1, 'Step 4: Rolling and Cutting', 'Divide the dough into quarters. Roll each piece into a thin sheet (about 1/8 inch thick) using a rolling pin or pasta machine. Cut into your desired shape - fettuccine, tagliatelle, or ravioli squares.', 6),
(1, 'Cooking Tips', 'Fresh pasta cooks much faster than dried pasta - usually 2-3 minutes in boiling salted water. The pasta is done when it floats to the surface and is tender but still has a slight bite (al dente).', 7);

-- Quizzes for Fresh Pasta Dough (lesson_id = 1)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(1, 'What is the main ingredient in traditional Italian pasta dough?', 'Semolina flour', 'All-purpose flour', 'Bread flour', 'Cake flour', 'Semolina flour gives pasta its characteristic texture and golden color.', 1),
(1, 'What is the ideal ratio of flour to eggs for pasta dough?', '100g flour to 1 egg', '200g flour to 1 egg', '50g flour to 1 egg', '150g flour to 1 egg', 'The traditional ratio is 100g of flour per egg, which creates the perfect dough consistency.', 2),
(1, 'How long should you knead pasta dough?', '8-10 minutes', '2-3 minutes', '15-20 minutes', '5-6 minutes', 'Kneading for 8-10 minutes develops the gluten and creates a smooth, elastic dough.', 3),
(1, 'Why do you let pasta dough rest before rolling?', 'To allow gluten to relax', 'To make it easier to roll', 'To save time later', 'To make it taste better', 'Resting allows the gluten to relax, making the dough easier to roll out.', 4);

-- Lesson Content for Classic Marinara (lesson_id = 2)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(2, 'Introduction', 'Marinara sauce is the quintessential Italian tomato sauce - simple, flavorful, and versatile. This sauce forms the base for many Italian dishes and is perfect for pasta, pizza, and more.', 1),
(2, 'Ingredients', 'You''ll need: 2 cans (28 oz each) San Marzano tomatoes, 1/4 cup olive oil, 4 cloves garlic (minced), 1/2 cup fresh basil (torn), 1 teaspoon salt, 1/2 teaspoon black pepper, and 1/4 teaspoon red pepper flakes (optional).', 2),
(2, 'Step 1: Preparing the Tomatoes', 'Drain the tomatoes and crush them by hand or use a food processor for a smoother sauce. San Marzano tomatoes are preferred for their sweet, low-acid flavor, but any quality canned tomatoes will work.', 3),
(2, 'Step 2: Sautéing the Garlic', 'Heat the olive oil in a large saucepan over medium heat. Add the minced garlic and sauté for 1-2 minutes until fragrant but not browned. Garlic burns easily, so keep a close eye on it.', 4),
(2, 'Step 3: Adding Tomatoes', 'Add the crushed tomatoes to the pan and stir to combine with the garlic. Add the salt, pepper, and red pepper flakes. Bring the sauce to a simmer.', 5),
(2, 'Step 4: Simmering', 'Reduce the heat to low and simmer the sauce for 30-45 minutes, stirring occasionally. The sauce will thicken and the flavors will develop. Add the torn basil leaves in the last 5 minutes of cooking.', 6),
(2, 'Serving Tips', 'This sauce can be used immediately or stored in the refrigerator for up to 5 days. It also freezes well for up to 3 months. Serve over pasta, use as a pizza sauce, or as a base for other Italian dishes.', 7);

-- Quizzes for Classic Marinara (lesson_id = 2)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(2, 'What type of tomatoes are preferred for marinara sauce?', 'San Marzano tomatoes', 'Cherry tomatoes', 'Roma tomatoes', 'Beefsteak tomatoes', 'San Marzano tomatoes from Italy are prized for their sweet, low-acid flavor.', 1),
(2, 'What herb is essential in marinara sauce?', 'Basil', 'Oregano', 'Thyme', 'Rosemary', 'Fresh basil adds the characteristic Italian flavor to marinara sauce.', 2),
(2, 'How long should you simmer marinara sauce?', '30-45 minutes', '10-15 minutes', '1-2 hours', '5-10 minutes', 'Simmering for 30-45 minutes allows flavors to develop and sauce to thicken properly.', 3),
(2, 'What should you do with garlic when making marinara?', 'Sauté until fragrant but not browned', 'Cook until dark brown', 'Add raw at the end', 'Skip garlic entirely', 'Garlic should be sautéed gently to release flavor without burning.', 4);

-- Lesson Content for Carbonara Sauce (lesson_id = 3)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(3, 'Ingredients', '100 g / 3.5 oz pancetta or guanciale, finely chopped; 80 g / 1/2 cup Parmesan cheese, or Pecorino Romano; 4 eggs, large; 450 g /1 lbs spaghetti; 1 garlic clove, peeled and crushed; 1 tbsp butter, optional; salt; black pepper', 1),
(3, 'Step 1: Cook the Spaghetti', 'Cook the spaghetti according to package instructions in a large pot filled with salted water.', 2),
(3, 'Step 2: Cook Pancetta/Bacon', 'Cook the chopped pancetta or bacon in a large pan with 1 or 2 whole cloves of garlic and 1 tbsp of butter until the fat is rendered, then discard the garlic. If using bacon, discard all but 1–2 tablespoons of fat.', 3),
(3, 'Step 3: Mix Eggs & Cheese', 'In a small bowl mix 1 whole egg and 3 egg yolks (reserve the whites for another use or freeze them) and freshly grated parmesan cheese until blended.', 4),
(3, 'Step 4: Combine Pasta & Pancetta', 'Once the pasta is cooked, drain it while reserving 1/2 cup of pasta water. Add the pasta directly to the pan with pancetta and about half of the reserved pasta water. Stir to coat, then take off the heat.', 5),
(3, 'Step 5: Make the Sauce', 'Pour the egg and Parmesan mixture into the spaghetti while tossing it with tongs the entire time. Toss quickly not to let the eggs curdle. Taste and season with more salt, pepper, and more grated parmesan if desired. Add more pasta water for a saucier texture.', 6);

-- Quizzes for Carbonara Sauce (lesson_id = 3)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(3, 'What meat is traditionally used in carbonara?', 'Pancetta or guanciale', 'Bacon', 'Sausage', 'Chicken', 'Pancetta or guanciale are the traditional Italian meats used in carbonara.', 1),
(3, 'Why do you reserve pasta water in carbonara?', 'To create a creamy sauce', 'To save water', 'To cool down the pasta', 'To wash dishes', 'The starchy pasta water helps create the creamy sauce texture.', 2),
(3, 'How should you cook the eggs in carbonara?', 'Gently with residual heat', 'Scramble them first', 'Boil them separately', 'Fry them hard', 'The residual heat from hot pasta gently cooks the eggs without scrambling them.', 3),
(3, 'What cheese is essential in carbonara?', 'Pecorino Romano', 'Mozzarella', 'Parmesan only', 'Cheddar', 'Pecorino Romano is the traditional cheese used in carbonara.', 4);

-- Lesson Content for Pesto Genovese (lesson_id = 4)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(4, 'Ingredients', '2 medium cloves garlic (10g); 2 tbsp pine nuts (30g); 3 oz basil leaves (85g); coarse sea salt; 21g Parmigiano Reggiano; 21g Pecorino Fiore Sardo; 3/4 cup (175ml) extra-virgin olive oil', 1),
(4, 'Step 1: Pound Garlic', 'Using a marble mortar and wooden pestle, pound the garlic to a paste.', 2),
(4, 'Step 2: Add Pine Nuts', 'Add pine nuts and crush with pestle until a sticky, slightly chunky beige paste forms.', 3),
(4, 'Step 3: Add Basil', 'Add basil leaves a handful at a time with a pinch of salt, grinding until all leaves are crushed to fine bits.', 4),
(4, 'Step 4: Add Cheese & Olive Oil', 'Add both cheeses, then slowly drizzle in olive oil, working it into the pesto with the pestle until a creamy sauce forms.', 5),
(4, 'Step 5: Serve or Store', 'Serve with pasta right away or cover with a thin layer of olive oil and refrigerate overnight.', 6);

-- Quizzes for Pesto Genovese (lesson_id = 4)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(4, 'What nuts are used in traditional pesto?', 'Pine nuts', 'Walnuts', 'Almonds', 'Cashews', 'Pine nuts are the traditional choice for authentic pesto Genovese.', 1),
(4, 'Why should basil be completely dry for pesto?', 'To prevent watery pesto', 'To make it taste better', 'To save time', 'To preserve color', 'Dry basil prevents the pesto from becoming watery.', 2),
(4, 'How should you add olive oil to pesto?', 'Slowly while processing', 'All at once', 'After processing', 'Skip olive oil', 'Adding oil slowly while processing creates the right emulsion.', 3),
(4, 'What cheese combination is traditional in pesto?', 'Parmigiano-Reggiano and Pecorino', 'Mozzarella only', 'Cheddar and Parmesan', 'No cheese', 'The traditional combination is Parmigiano-Reggiano and Pecorino Romano.', 4);

-- Lesson Content for Pizza Dough (lesson_id = 5)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(5, 'Ingredients', '¾ cup warm water; 1½ tsp sugar; 1 (¼-ounce) package active dry yeast; 2 cups all-purpose flour; 1 tsp sea salt; 1 tbsp + 1 tsp extra-virgin olive oil', 1),
(5, 'Step 1: Activate Yeast', 'In a small bowl, stir together the water, sugar, and yeast. Set aside for 5 minutes, until foamy.', 2),
(5, 'Step 2: Knead Dough', 'Turn the dough out onto a lightly floured surface and gently knead into a smooth ball.', 3),
(5, 'Step 3: First Rise', 'Brush a large bowl with 1 tsp olive oil and place dough inside. Cover and let rise until doubled, about 1 hour.', 4),
(5, 'Step 4: Shape Dough', 'Turn dough out onto a floured surface. Stretch to fit a 14-inch pizza pan or similar.', 5),
(5, 'Step 5: Top and Bake', 'Top as desired and bake 10–13 min in a 500°F oven, until crust is browned.', 6);

-- Quizzes for Pizza Dough (lesson_id = 5)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(5, 'What type of flour is best for pizza dough?', '00 flour or bread flour', 'Cake flour', 'All-purpose flour', 'Whole wheat flour', '00 flour or bread flour has the right protein content for pizza dough.', 1),
(5, 'How long should pizza dough rise?', '1-2 hours at room temperature', '30 minutes', 'Overnight in refrigerator', 'No rising needed', '1-2 hours at room temperature allows proper fermentation.', 2),
(5, 'What temperature should pizza be cooked at?', '500-550°F (260-290°C)', '350°F (175°C)', '400°F (200°C)', '600°F (315°C)', 'High heat creates the perfect crispy crust and melted cheese.', 3),
(5, 'Why do you punch down pizza dough?', 'To release air and redistribute yeast', 'To make it thinner', 'To save time', 'To make it taste better', 'Punching down releases air bubbles and redistributes the yeast.', 4);

-- Lesson Content for Margherita Pizza (lesson_id = 6)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(6, 'Introduction', 'Margherita highlights simple balance: tomato, mozzarella, basil.', 1),
(6, 'Dough & Sauce', 'Stretch dough gently; use a light, bright tomato sauce.', 2),
(6, 'Bake & Finish', 'Bake hot until leopard spotting; finish with fresh basil and oil.', 3);

-- Quizzes for Margherita Pizza (lesson_id = 6)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(6, 'What are the traditional toppings on a Margherita pizza?', 'Tomato sauce, mozzarella, basil', 'Pepperoni and cheese', 'Mushrooms and olives', 'Ham and pineapple', 'The Margherita represents the Italian flag colors: red, white, and green.', 1),
(6, 'What type of mozzarella is best for Margherita?', 'Fresh mozzarella', 'Shredded mozzarella', 'Processed cheese', 'Any cheese', 'Fresh mozzarella provides the best texture and flavor.', 2),
(6, 'When should you add basil to Margherita pizza?', 'After baking', 'Before baking', 'During baking', 'Never', 'Adding basil after baking preserves its fresh flavor and color.', 3),
(6, 'What does the Margherita pizza represent?', 'All of the above', 'Italian flag colors', 'Queen Margherita''s favorite', 'Traditional Italian ingredients', 'The Margherita represents the Italian flag and was named after Queen Margherita.', 4);

-- Lesson Content for Pizza Toppings (lesson_id = 7)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(7, 'Philosophy', 'Less is more. Avoid soggy pies by limiting moisture.', 1),
(7, 'Layering', 'Distribute evenly; place delicate items post-bake.', 2),
(7, 'Balance', 'Aim for salt, fat, acid balance across slices.', 3);

-- Quizzes for Pizza Toppings (lesson_id = 7)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(7, 'What''s the golden rule for pizza toppings?', 'Less is more', 'More is better', 'Use expensive ingredients', 'Mix sweet and savory', 'Too many toppings can make the pizza soggy and overwhelming.', 1),
(7, 'How should you arrange toppings on pizza?', 'Evenly distributed', 'All in the center', 'Only on the edges', 'Randomly scattered', 'Even distribution ensures every slice has a good balance of toppings.', 2),
(7, 'What should you do with wet ingredients?', 'Drain them well', 'Add extra cheese', 'Skip them entirely', 'Add more sauce', 'Wet ingredients can make the pizza soggy, so drain them thoroughly.', 3),
(7, 'When should you add delicate toppings?', 'After baking', 'Before baking', 'During baking', 'Never', 'Delicate toppings like fresh herbs should be added after baking to preserve their flavor.', 4);

-- Lesson Content for Wood-Fired Techniques (lesson_id = 8)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(8, 'Heat Management', 'Target 800–900°F. Preheat and maintain steady flame.', 1),
(8, 'Turning', 'Rotate every 20–30 seconds for even char.', 2),
(8, 'Floor Awareness', 'Use cooler/warmer zones to avoid burning.', 3);

-- Quizzes for Wood-Fired Techniques (lesson_id = 8)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(8, 'What temperature do wood-fired ovens reach?', '800-900°F (425-480°C)', '500°F (260°C)', '600°F (315°C)', '400°F (200°C)', 'Wood-fired ovens reach very high temperatures for authentic pizza cooking.', 1),
(8, 'How long does pizza cook in a wood-fired oven?', '60-90 seconds', '10-15 minutes', '5-7 minutes', '20-25 minutes', 'The high heat cooks pizza very quickly in wood-fired ovens.', 2),
(8, 'What wood is best for pizza ovens?', 'Hardwoods like oak or maple', 'Softwoods like pine', 'Any wood', 'No wood needed', 'Hardwoods burn hotter and longer, providing consistent heat.', 3),
(8, 'Why rotate pizza in a wood-fired oven?', 'For even cooking', 'To show off', 'To save time', 'It''s not necessary', 'Rotation ensures the pizza cooks evenly on all sides.', 4);

-- Lesson Content for Marinara Sauce (lesson_id = 9)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(9, 'Tomatoes', 'Use high-quality whole tomatoes; crush by hand.', 1),
(9, 'Sauté & Simmer', 'Gently sauté garlic; simmer briefly to preserve freshness.', 2),
(9, 'Finish', 'Season, add basil off heat for aroma.', 3);

-- Quizzes for Marinara Sauce (lesson_id = 9)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(9, 'What''s the difference between marinara and other tomato sauces?', 'It''s simpler and quicker', 'It has more ingredients', 'It''s always spicy', 'It''s always sweet', 'Marinara is a simple, quick-cooking sauce with minimal ingredients.', 1),
(9, 'How long should marinara sauce simmer?', '20-30 minutes', '2-3 hours', '5-10 minutes', 'Overnight', 'Marinara cooks quickly to preserve the bright, fresh tomato flavor.', 2),
(9, 'What gives marinara its bright flavor?', 'Fresh herbs and minimal cooking', 'Long cooking time', 'Lots of spices', 'Sugar', 'Minimal cooking and fresh herbs preserve the bright tomato flavor.', 3),
(9, 'When should you add herbs to marinara?', 'At the end of cooking', 'At the beginning', 'Never', 'After serving', 'Adding herbs at the end preserves their fresh flavor.', 4);

-- Lesson Content for Alfredo Sauce (lesson_id = 10)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(10, 'Emulsion', 'Create creamy texture by emulsifying butter and cheese.', 1),
(10, 'Pasta Water', 'Starchy water adjusts consistency without cream.', 2),
(10, 'Serve', 'Toss quickly off heat to prevent splitting.', 3);

-- Quizzes for Alfredo Sauce (lesson_id = 10)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(10, 'What is the base of Alfredo sauce?', 'Butter and cheese', 'Cream and flour', 'Olive oil', 'Milk', 'Traditional Alfredo sauce is made with butter and cheese, not cream.', 1),
(10, 'What cheese is essential in Alfredo sauce?', 'Parmigiano-Reggiano', 'Mozzarella', 'Cheddar', 'Blue cheese', 'Parmigiano-Reggiano provides the authentic flavor and texture.', 2),
(10, 'How should you add pasta water to Alfredo?', 'Gradually while stirring', 'All at once', 'Never add pasta water', 'After serving', 'Gradual addition while stirring creates the perfect creamy consistency.', 3),
(10, 'What makes Alfredo sauce creamy?', 'Emulsification of butter and cheese', 'Adding cream', 'Using flour', 'Adding milk', 'The emulsification of butter and cheese creates the creamy texture.', 4);

-- Lesson Content for Pesto Sauce (lesson_id = 11)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(11, 'Basil & Nuts', 'Use fresh basil; pine nuts or walnuts as variation.', 1),
(11, 'Grinding', 'Pound garlic and nuts before basil for best texture.', 2),
(11, 'Oil & Cheese', 'Stream oil; fold cheeses to finish.', 3);

-- Quizzes for Pesto Sauce (lesson_id = 11)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(11, 'What region of Italy is pesto from?', 'Liguria', 'Tuscany', 'Sicily', 'Veneto', 'Pesto Genovese originates from the Liguria region of Italy.', 1),
(11, 'What tool is traditional for making pesto?', 'Mortar and pestle', 'Food processor', 'Blender', 'Hand mixer', 'Traditional pesto is made with a mortar and pestle for the best texture.', 2),
(11, 'How should you store pesto?', 'Covered with olive oil', 'In water', 'In the freezer', 'In the sun', 'Covering with olive oil prevents oxidation and preserves the pesto.', 3),
(11, 'What gives pesto its vibrant green color?', 'Fresh basil', 'Food coloring', 'Spinach', 'Parsley', 'Fresh basil leaves give pesto its characteristic vibrant green color.', 4);

-- Lesson Content for Arrabbiata Sauce (lesson_id = 12)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(12, 'Chili Heat', 'Use dried or fresh chilies; control heat early in oil.', 1),
(12, 'Tomato Base', 'Add tomatoes; simmer briefly for a bright, spicy sauce.', 2),
(12, 'Pairing', 'Serve traditionally with penne; finish with parsley.', 3);

-- Quizzes for Arrabbiata Sauce (lesson_id = 12)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(12, 'What does ''arrabbiata'' mean in Italian?', 'Angry', 'Spicy', 'Hot', 'Red', 'Arrabbiata means ''angry'' in Italian, referring to the spicy heat.', 1),
(12, 'What gives arrabbiata its heat?', 'Red chili peppers', 'Black pepper', 'Cayenne pepper', 'Jalapeños', 'Red chili peppers are the traditional source of heat in arrabbiata.', 2),
(12, 'How should you handle the chili in arrabbiata?', 'Sauté with garlic', 'Add raw', 'Skip it', 'Add at the end', 'Sautéing the chili with garlic releases its flavor and heat properly.', 3),
(12, 'What pasta is traditional with arrabbiata?', 'Penne', 'Spaghetti', 'Fettuccine', 'Any pasta', 'Penne is the traditional pasta shape served with arrabbiata sauce.', 4);

-- Lesson Content for Tiramisu (lesson_id = 13)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(13, 'Mascarpone Cream', 'Whip yolks with sugar; fold in mascarpone and whipped cream.', 1),
(13, 'Assembly', 'Dip ladyfingers in espresso; layer with cream; chill.', 2),
(13, 'Finish', 'Dust with cocoa before serving.', 3);

-- Quizzes for Tiramisu (lesson_id = 13)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(13, 'What does ''tiramisu'' mean?', 'Pick me up', 'Coffee cake', 'Sweet dessert', 'Italian treat', 'Tiramisu means ''pick me up'' in Italian, referring to the coffee content.', 1),
(13, 'What type of coffee is used in tiramisu?', 'Espresso', 'Regular coffee', 'Decaf coffee', 'Instant coffee', 'Espresso provides the authentic Italian coffee flavor for tiramisu.', 2),
(13, 'What cheese is essential in tiramisu?', 'Mascarpone', 'Cream cheese', 'Ricotta', 'Cottage cheese', 'Mascarpone is the traditional Italian cheese used in tiramisu.', 3),
(13, 'How should you layer tiramisu?', 'Ladyfingers, coffee, mascarpone mixture', 'All mixed together', 'Randomly', 'Only mascarpone', 'Traditional layering: ladyfingers soaked in coffee, then mascarpone mixture.', 4);

-- Lesson Content for Cannoli (lesson_id = 14)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(14, 'Shells', 'Prepare stiff dough; roll thin; fry until blistered.', 1),
(14, 'Filling', 'Sweetened ricotta with citrus zest and chocolate chips.', 2),
(14, 'Fill & Serve', 'Fill just before serving to maintain crunch.', 3);

-- Quizzes for Cannoli (lesson_id = 14)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(14, 'What region of Italy are cannoli from?', 'Sicily', 'Tuscany', 'Lombardy', 'Veneto', 'Cannoli are a traditional Sicilian dessert.', 1),
(14, 'What is the shell of cannoli made from?', 'Fried pastry dough', 'Baked dough', 'Phyllo dough', 'Puff pastry', 'Cannoli shells are made from fried pastry dough.', 2),
(14, 'What cheese is used in cannoli filling?', 'Ricotta', 'Mascarpone', 'Cream cheese', 'Cottage cheese', 'Ricotta cheese is the traditional filling for cannoli.', 3),
(14, 'How should cannoli be filled?', 'Just before serving', 'Days in advance', 'While hot', 'Never', 'Cannoli should be filled just before serving to keep the shell crispy.', 4);

-- Lesson Content for Panna Cotta (lesson_id = 15)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(15, 'Base', 'Bloom gelatin; warm cream with sugar and vanilla.', 1),
(15, 'Set', 'Combine and chill until just set with a gentle wobble.', 2),
(15, 'Serve', 'Unmold carefully; serve with fruit coulis.', 3);

-- Quizzes for Panna Cotta (lesson_id = 15)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(15, 'What does ''panna cotta'' mean?', 'Cooked cream', 'Sweet cream', 'Vanilla cream', 'Italian cream', 'Panna cotta means ''cooked cream'' in Italian.', 1),
(15, 'What thickens panna cotta?', 'Gelatin', 'Flour', 'Cornstarch', 'Eggs', 'Gelatin is the traditional thickener for panna cotta.', 2),
(15, 'How should you serve panna cotta?', 'Chilled', 'Warm', 'Hot', 'Frozen', 'Panna cotta is served chilled for the best texture and flavor.', 3),
(15, 'What is the texture of panna cotta?', 'Silky and smooth', 'Thick and heavy', 'Light and fluffy', 'Crunchy', 'Panna cotta has a silky, smooth texture when properly made.', 4);

-- Lesson Content for Gelato (lesson_id = 16)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(16, 'Base', 'Lower-fat base churned slowly for dense texture.', 1),
(16, 'Churning', 'Limit overrun by slow churning; freeze slightly warmer.', 2),
(16, 'Flavor', 'Highlight classic fior di latte or simple fruit purées.', 3);

-- Quizzes for Gelato (lesson_id = 16)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(16, 'What makes gelato different from ice cream?', 'Less fat and air', 'More sugar', 'Different flavors', 'Different colors', 'Gelato has less fat and air than ice cream, making it denser.', 1),
(16, 'What temperature is gelato served at?', 'Warmer than ice cream', 'Colder than ice cream', 'Same as ice cream', 'Frozen solid', 'Gelato is served at a warmer temperature than ice cream.', 2),
(16, 'What gives gelato its dense texture?', 'Less air churned in', 'More fat', 'More sugar', 'Different milk', 'Less air is churned into gelato, creating a denser texture.', 3),
(16, 'What is the traditional gelato flavor?', 'Fior di latte (milk)', 'Vanilla', 'Chocolate', 'Strawberry', 'Fior di latte (milk) is the traditional, pure gelato flavor.', 4);

-- Lesson Content for additional lessons (ids 17-40)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(17, 'Introduction', 'Overview of slow-simmered ragù technique.', 1),
(17, 'Core Steps', 'Build soffritto, brown meat, deglaze, and simmer.', 2),
(18, 'Introduction', 'Ravioli sheet making and sealing fundamentals.', 1),
(18, 'Core Steps', 'Roll thin sheets, add filling, seal, and cook.', 2),
(19, 'Introduction', 'Orderly layering with structured sauces and sheets.', 1),
(19, 'Core Steps', 'Par-cook sheets, layer, rest, and slice.', 2),
(20, 'Introduction', 'Light, tender gnocchi from floury potatoes.', 1),
(20, 'Core Steps', 'Rice potatoes, add flour/egg, minimal mixing.', 2),
(21, 'Introduction', 'Cheese and pepper emulsion without cream.', 1),
(21, 'Core Steps', 'Temper cheese with pasta water; toss off heat.', 2),
(22, 'Introduction', 'Folding and shaping rings with sealed edges.', 1),
(22, 'Core Steps', 'Cut, fill, fold, and seal tortellini.', 2),
(23, 'Introduction', 'Neapolitan method and oven management.', 1),
(23, 'Core Steps', 'High-heat bake, quick rotation, soft cornicione.', 2),
(24, 'Introduction', 'NY dough style and fermentation.', 1),
(24, 'Core Steps', 'Cold ferment, stretch, bake for crisp foldable slice.', 2),
(25, 'Introduction', 'Oily pan and airy crumb for Sicilian pies.', 1),
(25, 'Core Steps', 'Pan proof, dimple, top, and bake.', 2),
(26, 'Introduction', 'Sealed, filled dough bakes into a pocket.', 1),
(26, 'Core Steps', 'Roll, fill, crimp, vent, and bake.', 2),
(27, 'Introduction', 'Moisture and melt control for clean bakes.', 1),
(27, 'Core Steps', 'Drain toppings; balance sauce and cheese.', 2),
(28, 'Introduction', 'Preferments and time for flavor and texture.', 1),
(28, 'Core Steps', 'Make poolish/biga; cold ferment for depth.', 2),
(29, 'Introduction', 'Layered ragù with balanced acidity.', 1),
(29, 'Core Steps', 'Sear, deglaze, simmer, finish with milk.', 2),
(30, 'Introduction', 'Guanciale-tomato sauce with pecorino.', 1),
(30, 'Core Steps', 'Render guanciale; toss with tomato and cheese.', 2),
(31, 'Introduction', 'Briny sauce with olives, capers, anchovies.', 1),
(31, 'Core Steps', 'Bloom anchovies; add tomatoes and aromatics.', 2),
(32, 'Introduction', 'Milk-based white sauce with roux.', 1),
(32, 'Core Steps', 'Cook roux; whisk in milk gradually.', 2),
(33, 'Introduction', 'Tomato-cream sauce brightened with vodka.', 1),
(33, 'Core Steps', 'Reduce vodka; add tomato and cream.', 2),
(34, 'Introduction', 'Savory mushroom reduction for pasta.', 1),
(34, 'Core Steps', 'Brown mushrooms; deglaze and reduce.', 2),
(35, 'Introduction', 'Egg foam dessert flavored with wine.', 1),
(35, 'Core Steps', 'Whisk over bain-marie; serve warm.', 2),
(36, 'Introduction', 'Crisp cookies baked twice.', 1),
(36, 'Core Steps', 'Form logs, bake, slice warm, bake again.', 2),
(37, 'Introduction', 'Thin pressed cookies with anise.', 1),
(37, 'Core Steps', 'Press in iron; cool to crisp.', 2),
(38, 'Introduction', 'Laminated shells with ricotta filling.', 1),
(38, 'Core Steps', 'Laminate, shape shells, bake, fill.', 2),
(39, 'Introduction', 'Tall enriched holiday bread.', 1),
(39, 'Core Steps', 'Long ferment; hang to cool.', 2),
(40, 'Introduction', 'Fried dough puffs sometimes filled.', 1),
(40, 'Core Steps', 'Pipe, fry, drain; fill after frying.', 2);

-- Quizzes for additional lessons (ids 17-40)
-- Pasta Basics additions
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(17, 'What is a key characteristic of ragù alla bolognese?', 'Slow-simmered meat sauce', 'Raw tomato purée', 'No aromatics', 'Cooked in 10 minutes', 'Bolognese is slowly simmered to develop depth.', 1),
(17, 'Which ingredient is traditional in bolognese?', 'Soffritto (onion, carrot, celery)', 'Cilantro', 'Coconut milk', 'Lemon zest', 'Soffritto forms the aromatic base.', 2),
(18, 'What seals ravioli well?', 'Egg wash or water on edges', 'Olive oil', 'Sugar syrup', 'Vinegar', 'A light egg wash or water helps seal pasta sheets.', 1),
(18, 'How thick should ravioli sheets be?', 'Thin but sturdy', 'Very thick', 'Paper-thin only', 'Unrolled', 'Thin sheets prevent bursting and cook evenly.', 2),
(19, 'What keeps lasagna layers distinct?', 'Properly thick béchamel and rested slices', 'Lots of water', 'No sauce', 'Freezing before baking', 'Structure and resting create clean layers.', 1),
(19, 'Why par-cook sheets?', 'To ensure tenderness', 'To add sweetness', 'For color only', 'To remove starch', 'Par-cooking avoids undercooked sheets.', 2),
(20, 'Which potato is best for gnocchi?', 'Floury potatoes (russet)', 'Waxy potatoes', 'New potatoes', 'Sweet potatoes only', 'Floury potatoes yield light gnocchi.', 1),
(20, 'What prevents tough gnocchi?', 'Minimal mixing', 'Extra kneading', 'Adding more flour', 'Rolling many times', 'Overworking makes them dense.', 2),
(21, 'What are the main ingredients in cacio e pepe?', 'Pecorino, black pepper, pasta water', 'Tomatoes and basil', 'Cream and butter', 'Anchovies and capers', 'The emulsion comes from cheese and starchy water.', 1),
(21, 'How to avoid clumping?', 'Temper cheese with warm water', 'Boil cheese', 'Add ice', 'Use cold pan', 'Tempering creates a smooth sauce.', 2),
(22, 'What shape is classic tortellini?', 'Ring-shaped (navel)', 'Bow tie', 'Tube', 'Shell', 'Tortellini are folded and sealed into a ring.', 1),
(22, 'Key to sealing tortellini?', 'Moistened edges and firm press', 'Lots of oil', 'Sugar', 'Butter', 'Proper sealing prevents bursting.', 2);

-- Pizza Mastery additions
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(23, 'Defining trait of Neapolitan pizza?', 'High heat and soft cornicione', 'Thick crust and low heat', 'Square shape', 'Heavy toppings', 'Neapolitan uses very high heat and a puffy rim.', 1),
(23, 'Typical bake time Neapolitan?', '60–90 seconds', '10 minutes', '30 minutes', '5 minutes', 'Extreme heat cooks quickly.', 2),
(24, 'NY-style fermentation often uses?', 'Cold ferment', 'No ferment', 'Hot proofing', 'Sourdough only', 'Cold ferment develops flavor.', 1),
(24, 'NY slice texture is?', 'Foldable with crisp underside', 'Cracker-thin', 'Deep-dish', 'Raw center', 'NY style balances crisp and pliable.', 2),
(25, 'Sicilian dough texture is?', 'Thick and airy', 'Thin and crackery', 'Dense and dry', 'Raw and wet', 'Pan baking yields airy crumb.', 1),
(25, 'Pan prep for Sicilian?', 'Generous oil in pan', 'Dry pan', 'Cornmeal only', 'Parchment only', 'Oil promotes frying and release.', 2),
(26, 'Calzone sealing technique?', 'Crimped edge and venting', 'No seal', 'Wet center', 'Slice top off', 'Sealed edge prevents leaks; venting releases steam.', 1),
(26, 'Difference between calzone and stromboli?', 'Folded vs rolled', 'Cheese vs no cheese', 'Baked vs fried', 'Round vs square', 'Calzone is folded; stromboli is rolled.', 2),
(27, 'How to prevent watery pizza?', 'Drain high-moisture toppings', 'Add more sauce', 'Lower temperature', 'Bake shorter', 'Moisture control is key.', 1),
(27, 'Cheese coverage ideal?', 'Even, not edge-to-edge oil slick', 'All the way to edge always', 'Random chunks only', 'No cheese', 'Balance melt and browning.', 2),
(28, 'Preferment example?', 'Poolish or biga', 'Sponge cake', 'Ganache', 'Roux', 'Preferments improve flavor and structure.', 1),
(28, 'Benefit of cold fermentation?', 'Flavor and digestibility', 'Color only', 'No difference', 'Spoils dough', 'Long, cold fermentation enhances flavor.', 2);

-- Italian Sauces additions
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(29, 'Classic bolognese base includes?', 'Soffritto and meat slowly cooked', 'Raw garlic only', 'Cream only', 'No aromatics', 'Soffritto is foundational.', 1),
(29, 'Finishing bolognese often uses?', 'Milk or cream to round acidity', 'More sugar', 'Vinegar', 'No adjustment', 'Dairy softens acidity and enriches.', 2),
(30, 'Amatriciana uses which meat?', 'Guanciale', 'Prosciutto cotto', 'Chicken', 'Beef', 'Guanciale renders savory fat.', 1),
(30, 'Which cheese for Amatriciana?', 'Pecorino Romano', 'Mozzarella', 'Ricotta', 'Cheddar', 'Pecorino is traditional.', 2),
(31, 'Puttanesca hallmark?', 'Olives, capers, anchovies', 'Heavy cream', 'Butter', 'No salt', 'Salty, briny elements define it.', 1),
(31, 'When to add anchovies?', 'Early to melt into oil', 'At the end raw', 'Never', 'Only as garnish', 'They dissolve and flavor the oil.', 2),
(32, 'Béchamel thickener?', 'Roux (flour + butter)', 'Corn syrup', 'Powdered milk', 'Gelatin', 'A cooked roux thickens milk.', 1),
(32, 'Avoid lumps by?', 'Whisking while adding milk gradually', 'Boiling hard immediately', 'Adding cold butter later', 'Skipping whisk', 'Gradual incorporation prevents lumps.', 2),
(33, 'Vodka role in sauce?', 'Emulsifies and brightens tomato', 'Sweetens sauce', 'Adds smokiness', 'Thickens by itself', 'Vodka helps emulsify and extract flavors.', 1),
(33, 'When to add cream?', 'After reducing vodka and tomato', 'At the start', 'Never', 'Only raw', 'Add cream once alcohol cooks off.', 2),
(34, 'Mushroom sauté key?', 'High heat to brown', 'Low heat covered', 'Boil in water', 'Add salt immediately', 'Browning builds flavor.', 1),
(34, 'Deglaze with?', 'Wine or stock', 'Milk', 'Water only', 'Oil', 'Deglazing captures fond.', 2);

-- Desserts & Pastries additions
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(35, 'Zabaglione cooked over?', 'Gentle bain-marie', 'Direct high heat', 'Microwave only', 'Oven roast', 'Gentle heat prevents curdling.', 1),
(35, 'Classic flavoring?', 'Marsala wine', 'Soy sauce', 'Balsamic', 'Lemon juice only', 'Marsala adds aroma.', 2),
(36, 'Biscotti are baked how?', 'Twice-baked', 'Steamed', 'Fried', 'Microwaved', 'Double baking yields crisp texture.', 1),
(36, 'When to slice biscotti?', 'While warm after first bake', 'Before first bake', 'After full cool', 'Never slice', 'Warm slicing prevents crumbling.', 2),
(37, 'Pizzelle pattern created by?', 'Patterned iron', 'Scoring knife', 'Deep fryer', 'Rolling pin', 'A pizzelle iron imprints pattern.', 1),
(37, 'Classic flavor?', 'Anise', 'Cocoa only', 'Soy', 'Peppermint extract', 'Anise is traditional.', 2),
(38, 'Sfogliatelle texture from?', 'Laminated layers', 'Yeast-only rise', 'No fat', 'Overmixing', 'Lamination creates crisp layers.', 1),
(38, 'Filling commonly uses?', 'Ricotta', 'Custard only', 'Whipped cream only', 'Shortbread', 'Ricotta filling is classic.', 2),
(39, 'Panettone requires?', 'Long, enriched fermentation', 'Quick no-knead only', 'No fermentation', 'Boiling', 'Enriched, slow fermentation builds flavor.', 1),
(39, 'Proper cooling method?', 'Hang upside down', 'Leave flat on pan', 'Compress under weight', 'Freeze immediately', 'Inversion prevents collapse.', 2),
(40, 'Zeppole are typically?', 'Fried dough puffs', 'Boiled dumplings', 'Baked crackers', 'Steamed buns', 'Zeppole are fried and often filled.', 1),
(40, 'When to fill zeppole?', 'After frying and cooling slightly', 'Before frying', 'During frying', 'Never', 'Filling after frying preserves texture.', 2);

-- Lesson Content for remaining skills
-- Bread & Baked Goods (lesson_ids 41–50)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(41, 'Introduction', 'Focaccia is an olive oil–rich bread with an open, airy crumb and crisp surface.', 1),
(41, 'Core Steps', 'Hydrate, fold, bulk ferment, dimple with oil and salt, then bake hot.', 2),
(41, 'Tips', 'Generous olive oil and proper fermentation create flavor and texture.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(42, 'Introduction', 'Ciabatta uses high hydration to achieve a light, open crumb.', 1),
(42, 'Core Steps', 'Preferment, stretch-and-folds, gentle shaping, stone bake with steam.', 2),
(42, 'Tips', 'Minimal handling preserves gas; bake until deeply colored.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(43, 'Introduction', 'Pane rustico is a rustic country loaf with crackling crust.', 1),
(43, 'Core Steps', 'Build gluten, bulk ferment, score, and bake with steam.', 2),
(43, 'Tips', 'Long, cool fermentation improves flavor complexity.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(44, 'Introduction', 'Grissini are thin, crisp breadsticks perfect for antipasti.', 1),
(44, 'Core Steps', 'Mix dough, rest, roll thin, brush with oil, and bake until crisp.', 2),
(44, 'Tips', 'Top with sesame or rosemary for variety.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(45, 'Introduction', 'Schiacciata is a Tuscan flatbread similar to focaccia.', 1),
(45, 'Core Steps', 'Stretch dough, dimple, season with oil and salt, bake hot.', 2),
(45, 'Tips', 'Add grapes or herbs for regional variations.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(46, 'Introduction', 'Pizza bianca is a simple Roman white pizza with olive oil and salt.', 1),
(46, 'Core Steps', 'High hydration, long ferment, stretch and bake until blistered.', 2),
(46, 'Tips', 'Finish with rosemary or sliced garlic for aroma.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(47, 'Introduction', 'Cornetti are Italian crescent pastries with tender layers.', 1),
(47, 'Core Steps', 'Enrich dough, laminate lightly, proof, and bake until golden.', 2),
(47, 'Tips', 'Avoid over-lamination to maintain softness.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(48, 'Introduction', 'Filone is a traditional Italian loaf; shaping affects crumb structure.', 1),
(48, 'Core Steps', 'Pre-shape gently, tighten surface, proof in couche, score and bake.', 2),
(48, 'Tips', 'Proper surface tension supports tall oven spring.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(49, 'Introduction', 'Biga is a firm preferment improving flavor and strength.', 1),
(49, 'Core Steps', 'Mix low-yeast biga, ferment cool, incorporate into final dough.', 2),
(49, 'Tips', 'Adjust hydration in final mix to account for biga.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(50, 'Introduction', 'Pane toscano is traditionally saltless with a hearty crumb.', 1),
(50, 'Core Steps', 'Mix, bulk ferment, shape boules, bake with strong steam.', 2),
(50, 'Tips', 'Pairs well with salty toppings to balance flavor.', 3);

-- Regional (Northern Italy) (lesson_ids 51–60)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(51, 'Introduction', 'Risotto alla Milanese is saffron-infused and creamy.', 1),
(51, 'Core Steps', 'Toast rice, add saffron-infused stock gradually, mantecare with butter.', 2),
(51, 'Tips', 'Maintain gentle simmer; stir to develop creaminess.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(52, 'Introduction', 'Porcini risotto highlights earthy mushroom flavors.', 1),
(52, 'Core Steps', 'Rehydrate porcini, sauté, then proceed with classic risotto method.', 2),
(52, 'Tips', 'Finish with parsley and Parmigiano-Reggiano.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(53, 'Introduction', 'Polenta basics yield a smooth, creamy texture.', 1),
(53, 'Core Steps', 'Whisk cornmeal into simmering liquid, stir often, finish with butter.', 2),
(53, 'Tips', 'Use low, steady heat to avoid scorching.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(54, 'Introduction', 'Whole-grain polenta has deeper flavor and rustic texture.', 1),
(54, 'Core Steps', 'Cook longer with ample liquid; adjust salt generously.', 2),
(54, 'Tips', 'Rest briefly to set, then stir before serving.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(55, 'Introduction', 'Vitello tonnato pairs chilled veal with tuna-caper sauce.', 1),
(55, 'Core Steps', 'Poach veal gently; blend tuna, mayo, capers; slice and sauce.', 2),
(55, 'Tips', 'Serve well-chilled; garnish with capers.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(56, 'Introduction', 'Bagna cauda is a warm anchovy-garlic dip with vegetables.', 1),
(56, 'Core Steps', 'Gently heat anchovy and garlic in oil/butter; serve warm.', 2),
(56, 'Tips', 'Keep heat low to prevent scorching or bitterness.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(57, 'Introduction', 'Pizzoccheri features buckwheat pasta, greens, and cheese.', 1),
(57, 'Core Steps', 'Boil pasta with greens; layer with cheese and butter.', 2),
(57, 'Tips', 'Use bitto or fontina for authentic melt.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(58, 'Introduction', 'Canederli are alpine bread dumplings served in broth.', 1),
(58, 'Core Steps', 'Soak bread in milk and egg; shape and simmer gently.', 2),
(58, 'Tips', 'Do not overwork to keep dumplings tender.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(59, 'Introduction', 'Spezzatino is a slow-cooked northern beef stew.', 1),
(59, 'Core Steps', 'Brown meat, add aromatics and stock; simmer until tender.', 2),
(59, 'Tips', 'Add root vegetables toward the end to avoid mushiness.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(60, 'Introduction', 'Bollito misto features assorted meats served with sauces.', 1),
(60, 'Core Steps', 'Simmer meats separately to ideal doneness; slice and serve.', 2),
(60, 'Tips', 'Serve with mostarda and salsa verde.', 3);

-- Regional (Southern Italy) (lesson_ids 61–70)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(61, 'Introduction', 'Orecchiette with broccoli rabe balances bitter greens and garlic.', 1),
(61, 'Core Steps', 'Blanch greens, sauté with garlic and chili; toss with pasta.', 2),
(61, 'Tips', 'Reserve pasta water to bind sauce.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(62, 'Introduction', 'Caponata is a sweet-sour Sicilian eggplant relish.', 1),
(62, 'Core Steps', 'Fry eggplant; stew with celery, olives, capers, vinegar.', 2),
(62, 'Tips', 'Best served at room temperature after resting.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(63, 'Introduction', 'Arancini are crispy fried rice balls with fillings.', 1),
(63, 'Core Steps', 'Cook risotto, chill, fill, bread, and fry until golden.', 2),
(63, 'Tips', 'Use sticky rice to hold shape well.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(64, 'Introduction', 'Pasta alla Norma features eggplant and ricotta salata.', 1),
(64, 'Core Steps', 'Fry eggplant; toss with tomato sauce and pasta; finish with cheese.', 2),
(64, 'Tips', 'Salt eggplant to reduce bitterness and moisture.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(65, 'Introduction', 'Sugo al tonno is a quick tuna tomato sauce.', 1),
(65, 'Core Steps', 'Sauté garlic and chili; add tomatoes and canned tuna; simmer briefly.', 2),
(65, 'Tips', 'Do not overcook tuna to keep texture.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(66, 'Introduction', 'Frittura di paranza is a mixed fry of small fish.', 1),
(66, 'Core Steps', 'Dust lightly in flour; fry hot in small batches; salt immediately.', 2),
(66, 'Tips', 'Serve with lemon for brightness.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(67, 'Introduction', 'Parmigiana di melanzane is a layered eggplant bake.', 1),
(67, 'Core Steps', 'Fry eggplant slices; layer with sauce and cheese; bake.', 2),
(67, 'Tips', 'Let rest before slicing for clean layers.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(68, 'Introduction', 'Sarde a beccafico are stuffed sardines with breadcrumbs and raisins.', 1),
(68, 'Core Steps', 'Spread filling, roll sardines, bake with bay and oil.', 2),
(68, 'Tips', 'Balance sweet and savory in the filling.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(69, 'Introduction', 'Taralli are crunchy ring-shaped snacks.', 1),
(69, 'Core Steps', 'Knead dough, shape rings, boil briefly, then bake.', 2),
(69, 'Tips', 'Season with fennel or black pepper.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(70, 'Introduction', 'Granita is a coarse shaved ice dessert served with brioche.', 1),
(70, 'Core Steps', 'Freeze sweetened liquid, scrape into crystals; bake brioche separately.', 2),
(70, 'Tips', 'Use strong flavors like coffee or lemon.', 3);

-- Antipasti & Salads (lesson_ids 71–80)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(71, 'Introduction', 'Bruschetta al pomodoro showcases ripe tomatoes and garlic.', 1),
(71, 'Core Steps', 'Toast bread, rub with garlic, top with tomato-basil mixture.', 2),
(71, 'Tips', 'Drain tomatoes to avoid sogginess.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(72, 'Introduction', 'Caprese balances tomato, mozzarella, and basil.', 1),
(72, 'Core Steps', 'Slice ingredients, season with salt, oil, and balsamic if desired.', 2),
(72, 'Tips', 'Use ripe tomatoes and fresh mozzarella.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(73, 'Introduction', 'Carpaccio presents thin raw beef with bright dressing.', 1),
(73, 'Core Steps', 'Freeze briefly to slice thin; dress with lemon and oil; add capers.', 2),
(73, 'Tips', 'Keep plates chilled for serving.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(74, 'Introduction', 'Tricolore salad combines bitter, peppery, and crunchy greens.', 1),
(74, 'Core Steps', 'Toss arugula, radicchio, and endive with light vinaigrette.', 2),
(74, 'Tips', 'Balance bitterness with a touch of sweetness.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(75, 'Introduction', 'Prosciutto e melone is a classic sweet-salty pairing.', 1),
(75, 'Core Steps', 'Slice ripe melon, drape with prosciutto; serve chilled.', 2),
(75, 'Tips', 'Choose fragrant, ripe melon for best flavor.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(76, 'Introduction', 'Crostini toscani features savory chicken liver pâté.', 1),
(76, 'Core Steps', 'Sauté aromatics and livers; blend with capers; spread on toasts.', 2),
(76, 'Tips', 'Finish with a splash of vin santo if available.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(77, 'Introduction', 'Insalata di mare is a marinated seafood salad.', 1),
(77, 'Core Steps', 'Poach seafood gently; marinate with lemon, oil, and herbs.', 2),
(77, 'Tips', 'Avoid overcooking to keep seafood tender.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(78, 'Introduction', 'Giardiniera is a crunchy pickled vegetable relish.', 1),
(78, 'Core Steps', 'Blanch vegetables; pack in vinegar brine; chill until crisp.', 2),
(78, 'Tips', 'Adjust spice level with chiles and peppercorns.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(79, 'Introduction', 'Panzanella is a bread salad that uses day-old bread.', 1),
(79, 'Core Steps', 'Toast or stale bread, toss with tomatoes and vinaigrette.', 2),
(79, 'Tips', 'Let rest to absorb dressing before serving.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(80, 'Introduction', 'Antipasto misto is a selection of cured meats, cheeses, and vegetables.', 1),
(80, 'Core Steps', 'Arrange components by flavor; include pickles and breads.', 2),
(80, 'Tips', 'Balance rich items with acidic elements.', 3);

-- Seafood & Fish (lesson_ids 81–90)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(81, 'Introduction', 'Spaghetti alle vongole pairs clams with garlic and white wine.', 1),
(81, 'Core Steps', 'Purge clams, sauté garlic, steam with wine; toss with pasta.', 2),
(81, 'Tips', 'Finish with parsley and lemon zest.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(82, 'Introduction', 'Acqua pazza gently poaches fish in aromatic broth.', 1),
(82, 'Core Steps', 'Simmer tomatoes, garlic, herbs; poach fish until just done.', 2),
(82, 'Tips', 'Do not boil; keep at a gentle simmer.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(83, 'Introduction', 'Salt-baked branzino yields moist, aromatic flesh.', 1),
(83, 'Core Steps', 'Encase fish in salt crust; bake and crack open at table.', 2),
(83, 'Tips', 'Do not oversalt flesh; crust protects moisture.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(84, 'Introduction', 'Fritto misto is a crisp mix of seafood.', 1),
(84, 'Core Steps', 'Dry seafood, dust lightly, fry hot, drain and salt.', 2),
(84, 'Tips', 'Fry in batches to keep temperature stable.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(85, 'Introduction', 'Cacciucco is a robust Tuscan fish stew.', 1),
(85, 'Core Steps', 'Build base with soffritto; add fish in stages by firmness.', 2),
(85, 'Tips', 'Serve over toasted garlic-rubbed bread.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(86, 'Introduction', 'Seared tuna showcases a rare center and citrus accents.', 1),
(86, 'Core Steps', 'Sear hot and fast; rest; slice against the grain.', 2),
(86, 'Tips', 'Avoid overcooking to keep texture.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(87, 'Introduction', 'Polpo alla Luciana braises octopus until tender.', 1),
(87, 'Core Steps', 'Simmer octopus with tomatoes, olives, and capers.', 2),
(87, 'Tips', 'Tenderness improves with gentle, long cooking.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(88, 'Introduction', 'Baccalà mantecato is a whipped salt cod spread.', 1),
(88, 'Core Steps', 'Soak salt cod; poach; whip with oil until creamy.', 2),
(88, 'Tips', 'Adjust salt after desalting; serve on crostini.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(89, 'Introduction', 'Calamari ripieni are stuffed squid baked in sauce.', 1),
(89, 'Core Steps', 'Stuff tubes, secure, nestle in tomato sauce; bake.', 2),
(89, 'Tips', 'Do not overcook to avoid toughness.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(90, 'Introduction', 'Zuppa di pesce is a hearty mixed seafood soup.', 1),
(90, 'Core Steps', 'Simmer aromatic broth; add seafood by cooking time.', 2),
(90, 'Tips', 'Finish with olive oil and fresh herbs.', 3);

-- Risotto & Grains (lesson_ids 91–100)
INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(91, 'Introduction', 'Risotto technique develops creaminess without cream.', 1),
(91, 'Core Steps', 'Toast rice, add stock gradually, stir, and mantecare.', 2),
(91, 'Tips', 'Keep stock hot; adjust salt late.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(92, 'Introduction', 'Lemon risotto is bright and aromatic.', 1),
(92, 'Core Steps', 'Zest and juice lemon; add near the end for freshness.', 2),
(92, 'Tips', 'Balance acidity with butter and cheese.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(93, 'Introduction', 'Porcini risotto emphasizes deep, earthy flavors.', 1),
(93, 'Core Steps', 'Use soaking liquid; sauté mushrooms separately; fold in.', 2),
(93, 'Tips', 'Finish with parsley and grated cheese.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(94, 'Introduction', 'Squid ink risotto has briny depth and dramatic color.', 1),
(94, 'Core Steps', 'Bloom ink in stock; add to risotto base; cook gently.', 2),
(94, 'Tips', 'Season carefully; ink is naturally savory.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(95, 'Introduction', 'Farro salad makes a hearty, herby side.', 1),
(95, 'Core Steps', 'Cook farro until tender; toss with vegetables and vinaigrette.', 2),
(95, 'Tips', 'Dress warm grains for better absorption.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(96, 'Introduction', 'Orzotto uses barley for a risotto-like texture.', 1),
(96, 'Core Steps', 'Toast barley; add stock gradually; finish with cheese.', 2),
(96, 'Tips', 'Cook slightly longer than rice for tenderness.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(97, 'Introduction', 'Vegetable risotto highlights seasonal produce.', 1),
(97, 'Core Steps', 'Sauté vegetables; fold into classic risotto base.', 2),
(97, 'Tips', 'Keep vegetables crisp-tender.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(98, 'Introduction', 'Radicchio risotto balances bitterness with richness.', 1),
(98, 'Core Steps', 'Sauté radicchio; deglaze with red wine; proceed with risotto.', 2),
(98, 'Tips', 'Finish with mascarpone for extra creaminess.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(99, 'Introduction', 'Farrotto combines farro with risotto technique.', 1),
(99, 'Core Steps', 'Toast farro; add stock; finish with mushrooms.', 2),
(99, 'Tips', 'Rest briefly before serving to set.', 3);

INSERT INTO lesson_content (lesson_id, section_title, content_text, order_index) VALUES
(100, 'Introduction', 'Finishing techniques perfect risotto texture and flavor.', 1),
(100, 'Core Steps', 'Mantecare with butter and cheese; adjust seasoning and plating.', 2),
(100, 'Tips', 'Serve immediately to preserve ideal texture.', 3);

-- Quizzes for remaining skills
-- Bread & Baked Goods (41–50)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(41, 'What creates focaccia\'s signature dimpled surface?', 'Pressing with oiled fingers before baking', 'Adding more sugar', 'Baking at low temperature', 'No fermentation', 'Dimples hold oil and salt and promote texture.', 1),
(41, 'Key to focaccia flavor?', 'Generous olive oil and proper fermentation', 'Extra water at plating', 'No salt', 'Butter only', 'Oil and fermentation drive flavor and crumb.', 2),
(42, 'Why is ciabatta dough very wet?', 'To create an open, irregular crumb', 'To bake faster', 'To add sweetness', 'To keep crust soft', 'High hydration yields large holes.', 1),
(42, 'Which handling preserves ciabatta structure?', 'Gentle stretch-and-folds', 'Vigorous kneading', 'Rolling pin flattening', 'Repeated punching down', 'Minimal handling keeps gas in the dough.', 2),
(43, 'What improves pane rustico flavor?', 'Long, cool fermentation', 'Extra sugar', 'Excess yeast', 'No salt', 'Slow fermentation builds complexity.', 1),
(43, 'What helps crust development?', 'Steam during early bake', 'Low oven temp', 'Closed oven vent', 'Oil brushing before bake', 'Steam delays crust set for better expansion.', 2),
(44, 'Defining trait of grissini?', 'Thin and crisp breadsticks', 'Soft and fluffy rolls', 'Dense loaves', 'Filled pastries', 'Grissini are meant to be crisp.', 1),
(44, 'Topping often used on grissini?', 'Sesame or rosemary', 'Chocolate chips', 'Powdered sugar', 'Ketchup', 'Savory seeds and herbs are common.', 2),
(45, 'Schiacciata is closest to?', 'Tuscan-style focaccia', 'Sweet brioche', 'Stuffed calzone', 'Pasta dough', 'It is a flatbread like focaccia.', 1),
(45, 'Before baking schiacciata you should?', 'Dimple and oil the surface', 'Freeze the dough', 'Add cream', 'Boil it', 'Dimples help retain oil and salt.', 2),
(46, 'Pizza bianca is typically topped with?', 'Olive oil and salt', 'Tomato sauce and sausage', 'Chocolate', 'Cream', 'It is a white pizza without sauce.', 1),
(46, 'A hallmark of pizza bianca texture?', 'Blistered crust with light interior', 'Very dense crumb', 'Soggy bottom', 'Raw center', 'High heat gives blistered crust.', 2),
(47, 'Cornetti differ from French croissants by being?', 'Softer and slightly sweeter', 'Savory only', 'Unleavened', 'Fried', 'Cornetti are tender and often sweeter.', 1),
(47, 'To keep cornetti tender you should?', 'Avoid excessive lamination', 'Add lots of water after baking', 'Proof in the freezer', 'Use only whole wheat', 'Over-lamination can make them tough.', 2),
(48, 'A goal when shaping a filone loaf?', 'Create strong surface tension', 'Remove all gas', 'Keep seam on top', 'No scoring', 'Tension supports oven spring.', 1),
(48, 'Proper proofing support for filone?', 'Proof in a couche or on a board', 'Hang vertically', 'Water bath proof', 'Fry before baking', 'Couche helps hold shape.', 2),
(49, 'What is a biga?', 'A firm preferment', 'A sweet glaze', 'A frying oil', 'A sauce', 'Biga boosts flavor and strength.', 1),
(49, 'How is biga typically fermented?', 'Cool and slow with little yeast', 'Very hot and fast', 'Without flour', 'Only in sealed jars', 'Slow fermentation develops flavor.', 2),
(50, 'Pane toscano traditionally lacks?', 'Salt in the dough', 'Yeast', 'Water', 'Flour', 'It is a saltless bread.', 1),
(50, 'What pairs well with pane toscano?', 'Salty toppings to balance bland crumb', 'Sweet syrups', 'Raw dough', 'Ice cream', 'Saltless bread complements salty foods.', 2);

-- Regional (Northern Italy) (51–60)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(51, 'Color of risotto alla Milanese comes from?', 'Saffron', 'Turmeric', 'Paprika', 'Spinach', 'Saffron gives golden color and aroma.', 1),
(51, 'Finishing risotto is called?', 'Mantecatura', 'Pate a bombe', 'Autolyse', 'Temper', 'Mantecatura adds butter/cheese for creaminess.', 2),
(52, 'Key flavor in mushroom risotto?', 'Porcini mushrooms', 'Mint', 'Coconut', 'Banana', 'Porcini provide deep flavor.', 1),
(52, 'Use soaking liquid for?', 'Boost mushroom flavor', 'Add sweetness', 'Cool the pan', 'Thicken with flour', 'Soaking liquid is flavorful.', 2),
(53, 'Stirring polenta prevents?', 'Lumps and scorching', 'Fermentation', 'Browning', 'Leavening', 'Consistent stirring is crucial.', 1),
(53, 'Finish polenta with?', 'Butter and cheese', 'Vinegar only', 'Icing sugar', 'Whipped cream', 'Fat enriches texture.', 2),
(54, 'Whole-grain polenta needs?', 'Longer cooking and more liquid', 'Less water', 'High heat boil', 'No salt', 'Whole grains hydrate slower.', 1),
(54, 'Resting polenta does what?', 'Sets structure before serving', 'Overcooks it', 'Removes flavor', 'Makes it raw', 'Brief rest improves texture.', 2),
(55, 'Vitello tonnato is served?', 'Chilled with tuna-caper sauce', 'Boiling hot', 'Deep-fried', 'Frozen', 'It is typically served cold.', 1),
(55, 'Sauce components include?', 'Tuna, mayo, capers', 'Chocolate, milk, sugar', 'Tomatoes only', 'Cheddar and butter', 'Classic tuna-caper emulsion.', 2),
(56, 'Bagna cauda is a dip based on?', 'Anchovy and garlic', 'Tomatoes and sugar', 'Chocolate and cream', 'Milk and cereal', 'Anchovy-garlic base warmed in oil.', 1),
(56, 'Heat for bagna cauda should be?', 'Gentle to avoid scorching', 'Very high', 'Microwave only', 'Broil', 'Low heat preserves flavor.', 2),
(57, 'Pizzoccheri noodles are made with?', 'Buckwheat flour', 'Rice flour', 'Chickpea flour', 'No flour', 'Buckwheat is traditional.', 1),
(57, 'Pizzoccheri is layered with?', 'Cheese, butter, and greens', 'Chocolate and cream', 'Pesto only', 'Fruit', 'Rich, savory layering is classic.', 2),
(58, 'Canederli are what?', 'Bread dumplings', 'Fried doughnuts', 'Pasta tubes', 'Raw cakes', 'They are bread-based dumplings.', 1),
(58, 'Cooking canederli requires?', 'Gentle simmer', 'Hard boil', 'Deep fry', 'Bake only', 'Gentle heat prevents breakage.', 2),
(59, 'Spezzatino cooking method?', 'Slow braise/stew', 'Quick fry', 'Raw cure', 'Smoke only', 'It is a stew.', 1),
(59, 'Add root vegetables when?', 'Toward the end', 'At the start for mush', 'Never', 'Only raw at table', 'Prevents overcooking.', 2),
(60, 'Bollito misto is a plate of?', 'Assorted boiled meats with sauces', 'Raw fish', 'Cakes', 'Pasta only', 'Multiple meats served with condiments.', 1),
(60, 'Classic condiment for bollito?', 'Mostarda or salsa verde', 'Chocolate sauce', 'Ketchup', 'Maple syrup', 'These balance the rich meats.', 2);

-- Regional (Southern Italy) (61–70)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(61, 'A hallmark of orecchiette e cime di rapa?', 'Bitter greens with garlic and chili', 'Heavy cream sauce', 'No vegetables', 'Chocolate sauce', 'Broccoli rabe provides pleasant bitterness.', 1),
(61, 'To bind this pasta dish use?', 'Reserved pasta water', 'Extra sugar', 'Cold milk', 'Flour slurry', 'Starchy water creates emulsion.', 2),
(62, 'Caponata flavor profile is?', 'Sweet-sour', 'Only spicy', 'Only sweet', 'Extremely bitter', 'Agrodolce is key.', 1),
(62, 'Best serving temperature?', 'Room temperature after resting', 'Piping hot', 'Frozen', 'Boiling', 'Flavors bloom as it rests.', 2),
(63, 'Arancini are made from?', 'Chilled risotto shaped and fried', 'Raw rice fried directly', 'Bread only', 'Pasta sheets', 'Risotto provides structure.', 1),
(63, 'To keep arancini intact?', 'Chill rice and bread well before frying', 'Add water during frying', 'No breading', 'Microwave to cook', 'Chilling helps hold shape.', 2),
(64, 'Cheese in pasta alla Norma?', 'Ricotta salata', 'Blue cheese', 'Cheddar', 'Brie', 'Ricotta salata is traditional.', 1),
(64, 'Prepare eggplant by?', 'Salting/frying before tossing', 'Boiling', 'Raw', 'Freezing', 'Salting reduces bitterness and moisture.', 2),
(65, 'Sugo al tonno main protein?', 'Canned tuna', 'Chicken', 'Beef', 'Pork', 'Canned tuna is classic and quick.', 1),
(65, 'Avoid overcooking tuna by?', 'Adding near the end', 'Boiling long', 'Pressure cooking', 'Adding at start', 'Short simmer preserves texture.', 2),
(66, 'Frittura di paranza is?', 'Mixed fried small fish', 'Baked whole fish', 'Raw sashimi', 'Smoked fish', 'A crispy seafood fry.', 1),
(66, 'Key to crisp frying?', 'Hot oil and small batches', 'Warm oil and big batches', 'Cold oil', 'Lots of water', 'Temperature control is vital.', 2),
(67, 'Parmigiana di melanzane layers?', 'Fried eggplant, sauce, cheese', 'Raw eggplant only', 'Bread only', 'Cream layers', 'Classic layered bake.', 1),
(67, 'For clean slices you should?', 'Rest before cutting', 'Cut immediately', 'Freeze hot', 'Soak in water', 'Resting sets layers.', 2),
(68, 'Sarde a beccafico filling often includes?', 'Breadcrumbs and raisins', 'Bananas', 'Chocolate', 'Whipped cream', 'Sweet-savory balance is typical.', 1),
(68, 'Bake sardines with?', 'Bay leaves and olive oil', 'Heavy cream', 'Sugar syrup', 'Peanut butter', 'Aromatic bake is traditional.', 2),
(69, 'Taralli are?', 'Crunchy ring snacks', 'Soft cakes', 'Fried doughnuts', 'Souffles', 'They are crisp and savory.', 1),
(69, 'Boiling taralli before baking?', 'Improves texture and sheen', 'Overcooks them', 'Makes them sweet', 'Is unsafe', 'Brief boil is common.', 2),
(70, 'Granita texture should be?', 'Flaky ice crystals', 'Smooth gel', 'Solid block', 'Frothy foam', 'Scraped crystals define granita.', 1),
(70, 'Classic granita flavors include?', 'Coffee or lemon', 'Chocolate ice cream', 'Beef broth', 'Soy', 'Bright fruit or coffee is typical.', 2);

-- Antipasti & Salads (71–80)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(71, 'First step for bruschetta al pomodoro?', 'Toast bread and rub with garlic', 'Boil bread', 'Fry in sugar', 'Steam bread', 'Garlic-rubbed toast is base.', 1),
(71, 'To avoid soggy topping?', 'Drain diced tomatoes', 'Add water', 'Use cream', 'Blend into soup', 'Less moisture keeps bread crisp.', 2),
(72, 'Caprese ingredients are?', 'Tomato, mozzarella, basil', 'Ham and pineapple', 'Chicken and rice', 'Beef and beans', 'Three-ingredient classic.', 1),
(72, 'Season Caprese with?', 'Olive oil and salt', 'Soy sauce', 'Ketchup', 'Chocolate', 'Simple seasoning highlights freshness.', 2),
(73, 'Carpaccio is?', 'Thin raw beef slices', 'Cooked stew', 'Deep-fried strips', 'Baked meatloaf', 'Served raw and thin.', 1),
(73, 'Tip for slicing carpaccio?', 'Chill/freeze briefly for thin slices', 'Warm to room temp first', 'Boil then slice', 'Grind first', 'Firm meat slices thinly.', 2),
(74, 'Tricolore refers to?', 'Three-color salad', 'Two sauces', 'Four cheeses', 'One herb', 'Arugula, radicchio, endive.', 1),
(74, 'Balance bitterness how?', 'Add slightly sweet vinaigrette', 'No dressing', 'Heavy cream sauce', 'Boil greens', 'Sweetness tempers bitter.', 2),
(75, 'Prosciutto e melone combines?', 'Salty ham and sweet melon', 'Beef and beans', 'Fish and chocolate', 'Bread and water', 'Classic sweet-salty pairing.', 1),
(75, 'Best melon stage?', 'Ripe and fragrant', 'Underripe', 'Overripe mush', 'Frozen solid', 'Ripe melon enhances flavor.', 2),
(76, 'Crostini toscani spread is made from?', 'Chicken livers', 'Tomatoes only', 'Chocolate', 'Yogurt', 'Savory liver pâté is traditional.', 1),
(76, 'Aromatics often include?', 'Onion, capers, anchovy', 'Banana and cocoa', 'Cinnamon sugar', 'Vanilla', 'Savory aromatics add depth.', 2),
(77, 'Insalata di mare cooking key?', 'Gently poach seafood', 'Boil vigorously', 'Deep fry', 'Serve raw only', 'Gentle heat keeps seafood tender.', 1),
(77, 'Marinade includes?', 'Lemon, olive oil, herbs', 'Milk and sugar', 'Soy and ginger only', 'Chocolate', 'Bright citrus dressing is common.', 2),
(78, 'Giardiniera is a?', 'Pickled vegetable relish', 'Creamy soup', 'Sweet jam', 'Fried snack', 'Vinegar pickled crunch.', 1),
(78, 'Crunch is preserved by?', 'Blanching then chilling in brine', 'Overcooking veggies', 'Adding baking soda', 'Freezing', 'Proper prep keeps snap.', 2),
(79, 'Panzanella uses?', 'Day-old bread', 'Fresh pasta', 'Rice noodles', 'Pie crust', 'Stale bread soaks dressing.', 1),
(79, 'Key step before serving?', 'Let salad rest to absorb dressing', 'Freeze it', 'Fry it', 'Blend smooth', 'Resting improves texture.', 2),
(80, 'Antipasto misto typically includes?', 'Cured meats, cheeses, vegetables', 'Only desserts', 'Only soup', 'Only bread', 'A mix of savory starters.', 1),
(80, 'Why include pickled items?', 'Cut richness of meats and cheeses', 'Make it spicy only', 'Add sweetness', 'For color only', 'Acid balances richness.', 2);

-- Seafood & Fish (81–90)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(81, 'Purge clams by?', 'Soaking in salted water', 'Boiling immediately', 'Freezing first', 'Microwaving', 'Purge grit before cooking.', 1), 
(81, 'Finish spaghetti alle vongole with?', 'Parsley and lemon zest', 'Heavy cream', 'Sugar', 'Cinnamon', 'Fresh herbs brighten the dish.', 2),
(82, 'Acqua pazza cooks fish how?', 'Gently poached in aromatic broth', 'Deep fried', 'Smoked', 'Raw cured', 'Gentle poach keeps fish tender.', 1),
(82, 'Add herbs when?', 'During poach for aroma', 'Only after serving', 'Before scaling', 'Never', 'Herbs perfume the broth.', 2),
(83, 'Salt crust for branzino does what?', 'Seals moisture in', 'Adds sweetness', 'Makes crust edible', 'Colors fish blue', 'Salt insulates during bake.', 1),
(83, 'To avoid oversalting flesh?', 'Do not let crust touch fillets directly', 'Add salt to flesh heavily', 'Soak in brine first', 'Cook uncovered', 'Crust protects exterior only.', 2),
(84, 'For crisp fritto misto, do?', 'Dry seafood and fry hot in batches', 'Coat heavily in batter', 'Overcrowd the pan', 'Fry at low temp', 'Dry and hot oil are crucial.', 1),
(84, 'Season when?', 'Immediately after frying', 'Before frying', 'After cooling fully', 'Never', 'Salt sticks best when hot.', 2),
(85, 'Cacciucco is a stew from?', 'Tuscany', 'Sicily', 'Lombardy', 'Piedmont', 'It is a Tuscan fish stew.', 1),
(85, 'Build flavor base with?', 'Soffritto and tomato', 'Chocolate syrup', 'Milk and flour', 'Banana', 'Classic stew base.', 2),
(86, 'Seared tuna doneness inside?', 'Rare to medium-rare', 'Well-done always', 'Raw frozen', 'Boiled', 'Quick sear leaves center rare.', 1),
(86, 'Slice tuna how?', 'Across the grain after rest', 'With the grain', 'Before cooking', 'Shredded', 'Slicing across grain improves texture.', 2),
(87, 'Key to tender octopus?', 'Slow, gentle braise', 'Rapid boil', 'Deep fry raw', 'Microwave only', 'Gentle cooking breaks down collagen.', 1),
(87, 'Flavorings include?', 'Tomato, olives, capers', 'Cocoa and honey', 'Cream and sugar', 'Soy and ginger only', 'Mediterranean flavors are classic.', 2),
(88, 'Baccalà requires?', 'Desalting by soaking', 'Extra salt added', 'No soaking', 'Frying only', 'Soaking removes excess salt.', 1),
(88, 'Texture is achieved by?', 'Whipping with oil', 'Adding flour', 'Boiling hard', 'Freezing', 'Emulsifying with oil creates creaminess.', 2),
(89, 'Stuffed squid are cooked by?', 'Baking in sauce', 'Raw curing', 'Smoking only', 'Deep frying only', 'Baking keeps them tender.', 1),
(89, 'Avoid toughness by?', 'Not overcooking', 'Boiling for hours', 'Freezing after', 'Pounding with hammer', 'Overcooking toughens squid.', 2),
(90, 'Zuppa di pesce composition?', 'Assorted seafood in broth', 'Only shrimp', 'Only raw fish', 'No liquid', 'Mixed seafood soup.', 1),
(90, 'Finish soup with?', 'Olive oil and herbs', 'Heavy cream', 'Powdered sugar', 'Cocoa', 'Fresh finish brightens flavor.', 2);

-- Risotto & Grains (91–100)
INSERT INTO quizzes (lesson_id, question_text, correct_answer, wrong_answer_1, wrong_answer_2, wrong_answer_3, explanation, order_index) VALUES
(91, 'Rice for risotto should be?', 'Arborio/Carnaroli types', 'Long-grain basmati', 'Instant rice', 'Wild rice only', 'Short-grain high-starch rice is ideal.', 1),
(91, 'Creaminess comes from?', 'Starch released by stirring', 'Heavy cream', 'Gelatin', 'Corn syrup', 'Agitation releases starch.', 2),
(92, 'Add lemon to risotto when?', 'Near the end to keep bright', 'At the start only', 'Never', 'With stock cold', 'Late addition preserves aroma.', 1),
(92, 'Balance acidity with?', 'Butter and cheese', 'More lemon only', 'Sugar', 'Cream only', 'Fat rounds sharpness.', 2),
(93, 'Porcini soaking liquid is?', 'Added to stock for flavor', 'Discarded', 'Used for dessert', 'Boiled away first', 'It boosts mushroom taste.', 1),
(93, 'Sauté mushrooms how?', 'Separately to brown', 'Boil them', 'Steam only', 'Puree raw', 'Browning deepens flavor.', 2),
(94, 'Squid ink does what?', 'Adds briny depth and color', 'Sweetens dish', 'Removes starch', 'Makes rice crunchy', 'Ink is savory and colorful.', 1),
(94, 'When to add ink?', 'Bloom and add with stock', 'At plating raw', 'At the start dry', 'Never', 'Even distribution via stock.', 2),
(95, 'Dress farro salad when?', 'While grains are warm', 'Only when cold', 'Before cooking', 'Never', 'Warm grains absorb dressing better.', 1),
(95, 'A grain used here is?', 'Farro', 'Couscous only', 'Rice only', 'Quinoa only', 'This lesson focuses on farro.', 2),
(96, 'Orzotto grain is?', 'Barley', 'Wheat berries', 'Corn', 'Millet', 'Barley mimics risotto texture.', 1),
(96, 'Cooking time compared to rice?', 'Slightly longer', 'Much shorter', 'Exactly the same', 'Needs no cooking', 'Barley cooks slower than rice.', 2),
(97, 'Vegetable risotto goal?', 'Keep veg crisp-tender', 'Cook vegetables to mush', 'Add sugar', 'Over-reduce stock', 'Texture contrast is pleasant.', 1),
(97, 'Add vegetables when?', 'Fold in near the end', 'From the start only', 'Never', 'Only raw on top', 'Prevents overcooking.', 2),
(98, 'Radicchio bitterness is balanced by?', 'Cheese and butter', 'Sugar syrup', 'Vinegar only', 'No seasoning', 'Fat rounds bitterness.', 1),
(98, 'Deglaze with?', 'Red wine', 'Milk', 'Beer only', 'Water only', 'Red wine enhances flavor and color.', 2),
(99, 'Farrotto uses technique from?', 'Risotto method', 'Baking cakes', 'Deep frying', 'Grilling', 'Same stirring and stock addition.', 1),
(99, 'Finish farrotto how?', 'With butter and cheese', 'With icing', 'With sugar syrup', 'With cocoa', 'Mantecatura applies here too.', 2),
(100, 'Final risotto step?', 'Mantecatura and immediate serving', 'Cooling overnight', 'Boiling dry', 'Deep frying', 'Serve right away at peak texture.', 1),
(100, 'Stock temperature should be?', 'Hot to maintain simmer', 'Cold from fridge', 'Frozen', 'Room temp only', 'Hot stock keeps cooking consistent.', 2);

-- Insert streak data
INSERT INTO streak (usr_id, curr_streak, longest_streak, last_active_dt) VALUES
(1, 5, 10, '2025-01-20'),
(2, 2, 4, '2025-01-19'),
(3, 0, 3, '2025-01-18'),
(4, 1, 2, '2025-01-20'),
(5, 3, 5, '2025-01-21'),
(6, 0, 1, '2025-01-15'),
(7, 4, 4, '2025-01-22'),
(8, 2, 3, '2025-01-19'),
(9, 6, 6, '2025-01-22'),
(10, 1, 3, '2025-01-18');

/* INSERT INTO user_achievements (user_id, achievement_id) VALUES
(1, 1),   -- Alice - Italian Novice
(1, 2),   -- Alice - Italian Intermediate
(1, 3),   -- Alice - Italian Expert
(1, 11),  -- Alice - Italian Ultra Expert
(2, 1),   -- Bob - Italian Novice
(2, 4),   -- Bob - Japanese Novice
(3, 7),   -- Charlie - Mexican Novice
(4, 4),   -- Diana - Japanese Novice
(5, 7),   -- Ethan - Mexican Novice
(5, 8),   -- Ethan - Mexican Intermediate
(6, 10),  -- Fiona - Streak Starter
(7, 2),   -- George - Italian Intermediate
(8, 5);   -- Hannah - Japanese Intermediate */

-- Insert sample user progress for new users (ids 4–13)
-- Note: lesson ids 1–16 exist per seed above
INSERT INTO user_progress (user_id, lesson_id, status, completed_at, score, created_at) VALUES
-- Diana (id 4): completed lesson 1, available lesson 2
(4, 1, 'completed', '2025-01-10 10:00:00', 100, NOW()),
(4, 2, 'available', NULL, 0, NOW()),
-- Ethan (id 5): completed lessons 1,2; available 3
(5, 1, 'completed', '2025-01-11 11:00:00', 100, NOW()),
(5, 2, 'completed', '2025-01-12 12:00:00', 100, NOW()),
(5, 3, 'available', NULL, 0, NOW()),
-- Fiona (id 6): available lesson 1
(6, 1, 'available', NULL, 0, NOW()),
-- George (id 7): completed pizza dough (lesson 5)
(7, 5, 'completed', '2025-01-13 09:30:00', 100, NOW()),
-- Hannah (id 8): completed 5,6; available 7
(8, 5, 'completed', '2025-01-14 08:45:00', 100, NOW()),
(8, 6, 'completed', '2025-01-15 08:45:00', 100, NOW()),
(8, 7, 'available', NULL, 0, NOW()),
-- Isaac (id 9): completed lesson 9; available 10
(9, 9, 'completed', '2025-01-16 14:20:00', 100, NOW()),
(9, 10, 'available', NULL, 0, NOW()),
-- Julia (id 10): no progress rows
-- Kevin (id 11): completed lessons 1 and 5
(11, 1, 'completed', '2025-01-17 17:00:00', 100, NOW()),
(11, 5, 'completed', '2025-01-18 17:00:00', 100, NOW()),
-- Luna (id 12): available lesson 13
(12, 13, 'available', NULL, 0, NOW()),
-- Mason (id 13): completed lessons 1–4
(13, 1, 'completed', '2025-01-05 09:00:00', 100, NOW()),
(13, 2, 'completed', '2025-01-06 09:00:00', 100, NOW()),
(13, 3, 'completed', '2025-01-07 09:00:00', 100, NOW()),
(13, 4, 'completed', '2025-01-08 09:00:00', 100, NOW());

-- Insert achievements data
INSERT INTO achievements (title, description, icon) VALUES
('Italian Novice', 'Your journey into Italian cuisine has begun! You''ve completed your first recipe.', 'it'),
('Italian Intermediate', 'You''re getting the hang of it! You''ve completed three Italian recipes.', 'it'),
('Italian Expert', 'Mamma mia! You''ve mastered the art of Italian cooking by completing all recipes.', 'it'),
('Italian Ultra Expert', 'You have transcended Italian cuisine, mastering advanced techniques and regional specialties beyond all recipes.', 'it'),
('Japanese Novice', 'A new path unfolds. You''ve completed your first Japanese recipe.', 'jp'),
('Japanese Intermediate', 'Your skills are sharpening. You''ve completed three Japanese recipes.', 'jp'),
('Japanese Expert', 'You have achieved culinary harmony. You''ve mastered all Japanese recipes.', 'jp'),
('Mexican Novice', '¡Qué bueno! You''ve cooked your first Mexican dish.', 'mx'),
('Mexican Intermediate', 'You''re spicing things up! You''ve completed three Mexican recipes.', 'mx'),
('Mexican Expert', 'You are a master of Mexican flavor! You''ve completed all Mexican recipes.', 'mx');

