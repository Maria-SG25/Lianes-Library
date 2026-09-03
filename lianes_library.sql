CREATE SCHEMA IF NOT EXISTS lianes_library
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;
 
USE lianes_library;
 
SET FOREIGN_KEY_CHECKS = 0;
 
DROP TABLE IF EXISTS activity_log;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS friends;
 
SET FOREIGN_KEY_CHECKS = 1;
 
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    genre VARCHAR(50),
    isbn VARCHAR(20) UNIQUE,
    status ENUM('Available', 'Borrowed') DEFAULT 'Available',
    rating DECIMAL(3,1) DEFAULT 0.0
);
 
CREATE TABLE friends (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(50),
    notes TEXT,
    max_loans INT DEFAULT 3
);
 
CREATE TABLE loans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    friend_id INT NOT NULL,
    loan_date DATE,
    return_date DATE DEFAULT NULL,
 
    INDEX idx_book_id (book_id),
    INDEX idx_friend_id (friend_id),
 
    CONSTRAINT fk_loans_book
        FOREIGN KEY (book_id)
        REFERENCES books(id)
        ON DELETE CASCADE,
 
    CONSTRAINT fk_loans_friend
        FOREIGN KEY (friend_id)
        REFERENCES friends(id)
        ON DELETE CASCADE
);
 
CREATE TABLE activity_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_title VARCHAR(255),
    borrower_name VARCHAR(255),
    action_type VARCHAR(50),
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    book_id INT,
    friend_id INT,
 
    INDEX idx_activity_book_id (book_id),
    INDEX idx_activity_friend_id (friend_id),
 
    CONSTRAINT fk_activity_book
        FOREIGN KEY (book_id)
        REFERENCES books(id)
        ON DELETE SET NULL,
 
    CONSTRAINT fk_activity_friend
        FOREIGN KEY (friend_id)
        REFERENCES friends(id)
        ON DELETE SET NULL
);
 
INSERT INTO books (title, author, genre, isbn, rating) VALUES
('Foundation', 'Isaac Asimov', 'Sci-Fi', '9780553293351', 5.0),
('Murder on the Orient Express', 'Agatha Christie', 'Mystery', '9780062693661', 7.0),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', '9780547928227', 8.0),
('Steve Jobs', 'Walter Isaacson', 'Biography', '9781451648539', 9.0),
('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 'Fantasy', '9780590353421', 10.0),
('The Da Vinci Code', 'Dan Brown', 'Thriller', '9780307474271', 4.0),
('Atomic Habits', 'James Clear', 'Self-help', '9780735211291', 9.0),
('The Girl with the Dragon Tattoo', 'Stieg Larsson', 'Thriller', '9780307454546', 7.0),
('Faust', 'Johann Wolfgang von Goethe', 'Classic', '9780140449013', 6.0),
('The Sorrows of Young Werther', 'Johann Wolfgang von Goethe', 'Classic', '9780140445039', 5.0),
('The Metamorphosis', 'Franz Kafka', 'Fiction', '9780553213690', 8.0),
('The Trial', 'Franz Kafka', 'Fiction', '9780805209991', 7.0),
('Steppenwolf', 'Hermann Hesse', 'Fiction', '9780312278674', 9.0),
('Siddhartha', 'Hermann Hesse', 'Philosophical', '9780553208849', 10.0),
('The Tin Drum', 'Günter Grass', 'Fiction', '9780156032063', 6.0),
('Perfume: The Story of a Murderer', 'Patrick Süskind', 'Thriller', '9780375725845', 8.0),
('All Quiet on the Western Front', 'Erich Maria Remarque', 'War', '9780449213940', 9.0),
('The Reader', 'Bernhard Schlink', 'Fiction', '9780375707971', 7.0),
('Demian', 'Hermann Hesse', 'Fiction', '9780142437179', 8.0),
('Berlin Alexanderplatz', 'Alfred Döblin', 'Classic', '9780826407849', 6.0),
('Homo Faber', 'Max Frisch', 'Fiction', '9780156421172', 5.0),
('The Physicists', 'Friedrich Dürrenmatt', 'Drama', '9780802144652', 9.0),
('The Visit', 'Friedrich Dürrenmatt', 'Drama', '9780802144263', 8.0),
('Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', 'Fantasy', '978-0747532699', 10.0),
('American Gods', 'Neil Gaiman', 'Fantasy', '978-0380973651', 9.0),
('Neverwhere', 'Neil Gaiman', 'Fantasy', '978-0553104752', 8.0),
('A Wizard of Earthsea', 'Ursula K. Le Guin', 'Fantasy', '978-0395276532', 7.0),
('The Left Hand of Darkness', 'Ursula K. Le Guin', 'Fantasy', '978-0441478125', 9.0),
('Harry Potter and the Chamber of Secrets', 'J.K. Rowling', 'Fantasy', '978-0439064866', 10.0),
('Harry Potter and the Prisoner of Azkaban', 'J.K. Rowling', 'Fantasy', '978-0439136358', 10.0),
('Good Omens', 'Neil Gaiman & Terry Pratchett', 'Fantasy', '978-0575048003', 9.0),
('The Dispossessed', 'Ursula K. Le Guin', 'Fantasy', '978-0060125639', 8.0),
('Animal Farm', 'George Orwell', 'Fantasy', '978-0451526342', 9.0),
('Stardust', 'Neil Gaiman', 'Fantasy', '978-0380977284', 7.0),
('The Tombs of Atuan', 'Ursula K. Le Guin', 'Fantasy', '978-0689206801', 6.0),
('The Man in the High Castle', 'Philip K. Dick', 'Science Fiction', '978-0618260300', 8.0),
('Foundation', 'Isaac Asimov', 'Science Fiction', '978-0553293357', 9.0),
('I, Robot', 'Isaac Asimov', 'Science Fiction', '978-0553294385', 8.0),
('Dune', 'Frank Herbert', 'Science Fiction', '978-0441172719', 10.0),
('Dune Messiah', 'Frank Herbert', 'Science Fiction', '978-0441172696', 9.0),
('The End of Eternity', 'Isaac Asimov', 'Science Fiction', '978-0765319197', 8.0),
('Do Androids Dream of Electric Sheep?', 'Philip K. Dick', 'Science Fiction', '978-0345404473', 9.0),
('Ubik', 'Philip K. Dick', 'Science Fiction', '978-0547572291', 7.0),
('Children of Dune', 'Frank Herbert', 'Science Fiction', '978-0441104024', 8.0),
('The Gods Themselves', 'Isaac Asimov', 'Science Fiction', '978-0385027014', 7.0),
('A Scanner Darkly', 'Philip K. Dick', 'Science Fiction', '978-0679736653', 6.0),
('VALIS', 'Philip K. Dick', 'Science Fiction', '978-0679734468', 5.0),
('Caves of Steel', 'Isaac Asimov', 'Science Fiction', '978-0553293128', 8.0),
('The Naked Sun', 'Isaac Asimov', 'Science Fiction', '978-0553293395', 7.0),
('Nineteen Eighty-Four', 'George Orwell', 'Dystopia', '978-0451524935', 10.0),
('The Handmaid''s Tale', 'Margaret Atwood', 'Dystopia', '978-0771008139', 9.0),
('Oryx and Crake', 'Margaret Atwood', 'Dystopia', '978-0771008153', 8.0),
('MaddAddam', 'Margaret Atwood', 'Dystopia', '978-0385520386', 7.0),
('The Road', 'Cormac McCarthy', 'Post-Apocalyptic', '978-0307387899', 9.0),
('Coraline', 'Neil Gaiman', 'Horror', '978-0380977789', 8.0),
('The Shining', 'Stephen King', 'Horror', '978-0385121675', 10.0),
('It', 'Stephen King', 'Horror', '978-0670813025', 9.0),
('Misery', 'Stephen King', 'Horror', '978-0670813643', 8.0),
('Pet Sematary', 'Stephen King', 'Horror', '978-0385182447', 9.0),
('Carrie', 'Stephen King', 'Horror', '978-0385086950', 7.0),
('The Stand', 'Stephen King', 'Horror', '978-0385121682', 10.0),
('Doctor Sleep', 'Stephen King', 'Horror', '978-1476727653', 8.0),
('Needful Things', 'Stephen King', 'Horror', '978-0670839537', 7.0),
('The Da Vinci Code', 'Dan Brown', 'Thriller', '978-0385504201', 6.0),
('Angels and Demons', 'Dan Brown', 'Thriller', '978-0671027353', 7.0),
('Inferno', 'Dan Brown', 'Thriller', '978-0385537858', 6.0),
('The Lost Symbol', 'Dan Brown', 'Thriller', '978-0385504225', 5.0),
('Origin', 'Dan Brown', 'Thriller', '978-0385514231', 6.0),
('Gone Girl', 'Gillian Flynn', 'Thriller', '978-0307588364', 9.0),
('Sharp Objects', 'Gillian Flynn', 'Thriller', '978-0307341556', 8.0),
('Dark Places', 'Gillian Flynn', 'Thriller', '978-0307341563', 7.0),
('The Grownup', 'Gillian Flynn', 'Thriller', '978-1101912119', 6.0),
('Murder on the Orient Express', 'Agatha Christie', 'Mystery', '978-0007119271', 9.0),
('And Then There Were None', 'Agatha Christie', 'Mystery', '978-0312330873', 10.0),
('Death on the Nile', 'Agatha Christie', 'Mystery', '978-0007119325', 8.0),
('The ABC Murders', 'Agatha Christie', 'Mystery', '978-0007119332', 8.0),
('Evil Under the Sun', 'Agatha Christie', 'Mystery', '978-0007119356', 7.0),
('The Murder at the Vicarage', 'Agatha Christie', 'Mystery', '978-0007120857', 6.0),
('Crooked House', 'Agatha Christie', 'Mystery', '978-0007120819', 7.0),
('Crime and Punishment', 'Fyodor Dostoevsky', 'Classic', '978-0140449136', 10.0),
('The Brothers Karamazov', 'Fyodor Dostoevsky', 'Classic', '978-0374528379', 10.0),
('The Idiot', 'Fyodor Dostoevsky', 'Classic', '978-0140447927', 9.0),
('Notes from Underground', 'Fyodor Dostoevsky', 'Classic', '978-0679734529', 8.0),
('War and Peace', 'Leo Tolstoy', 'Classic', '978-0307266903', 10.0),
('Anna Karenina', 'Leo Tolstoy', 'Classic', '978-0143035008', 10.0),
('The Death of Ivan Ilyich', 'Leo Tolstoy', 'Classic', '978-0307388865', 9.0),
('Resurrection', 'Leo Tolstoy', 'Classic', '978-0140446340', 7.0),
('The Old Man and the Sea', 'Ernest Hemingway', 'Classic', '978-0684801223', 9.0),
('A Farewell to Arms', 'Ernest Hemingway', 'Classic', '978-0684801469', 8.0),
('For Whom the Bell Tolls', 'Ernest Hemingway', 'Classic', '978-0684803357', 9.0),
('The Sun Also Rises', 'Ernest Hemingway', 'Classic', '978-0684800714', 8.0),
('One Hundred Years of Solitude', 'Gabriel García Márquez', 'Classic', '978-0060883287', 10.0),
('Love in the Time of Cholera', 'Gabriel García Márquez', 'Classic', '978-0307389732', 9.0),
('The Autumn of the Patriarch', 'Gabriel García Márquez', 'Classic', '978-0060882860', 7.0),
('Chronicle of a Death Foretold', 'Gabriel García Márquez', 'Classic', '978-1400034710', 8.0),
('Norwegian Wood', 'Haruki Murakami', 'Fiction', '978-0375704079', 8.0),
('Kafka on the Shore', 'Haruki Murakami', 'Fiction', '978-1400079278', 9.0),
('The Wind-Up Bird Chronicle', 'Haruki Murakami', 'Fiction', '978-0679775430', 9.0),
('1Q84', 'Haruki Murakami', 'Fiction', '978-0307593313', 8.0),
('Colorless Tsukuru Tazaki', 'Haruki Murakami', 'Fiction', '978-0385352109', 7.0),
('Blood Meridian', 'Cormac McCarthy', 'Fiction', '978-0679728757', 9.0),
('No Country for Old Men', 'Cormac McCarthy', 'Fiction', '978-0307387134', 8.0),
('All the Pretty Horses', 'Cormac McCarthy', 'Fiction', '978-0679744399', 8.0),
('Alias Grace', 'Margaret Atwood', 'Fiction', '978-0385490443', 8.0),
('Cat''s Eye', 'Margaret Atwood', 'Fiction', '978-0385491020', 7.0),
('The Alchemist', 'Paulo Coelho', 'Fiction', '978-0062315007', 8.0),
('Eleven Minutes', 'Paulo Coelho', 'Fiction', '978-0060589288', 6.0),
('Brida', 'Paulo Coelho', 'Fiction', '978-0061578953', 5.0),
('Sapiens', 'Yuval Noah Harari', 'Non-Fiction', '978-0062316097', 10.0),
('Homo Deus', 'Yuval Noah Harari', 'Non-Fiction', '978-0062464316', 9.0),
('21 Lessons for the 21st Century', 'Yuval Noah Harari', 'Non-Fiction', '978-0525512172', 8.0),
('A Moveable Feast', 'Ernest Hemingway', 'Non-Fiction', '978-0684824994', 9.0),
('What Is Art?', 'Leo Tolstoy', 'Non-Fiction', '978-0140446425', 7.0),
('The Story of a Shipwrecked Sailor', 'Gabriel García Márquez', 'Non-Fiction', '978-0679722052', 7.0),
('Homage to Catalonia', 'George Orwell', 'Non-Fiction', '978-0156421171', 8.0),
('The Road to Wigan Pier', 'George Orwell', 'Non-Fiction', '978-0156777506', 7.0),
('Death in the Afternoon', 'Ernest Hemingway', 'Non-Fiction', '978-0684801452', 6.0),
('Manual of the Warrior of Light', 'Paulo Coelho', 'Non-Fiction', '978-0060527983', 7.0),
('Underground: The Tokyo Gas Attack', 'Haruki Murakami', 'Non-Fiction', '978-0375725807', 8.0),
('A Writer''s Diary', 'Fyodor Dostoevsky', 'Non-Fiction', '978-0810125216', 8.0),
('Suttree', 'Cormac McCarthy', 'Fiction', '978-0679736325', 8.0),
('Harry Potter and the Goblet of Fire', 'J.K. Rowling', 'Fantasy', '978-0439139595', 10.0),
('Unstoppable Us', 'Yuval Noah Harari', 'Non-Fiction', '978-0593482933', 9.0);
 
INSERT INTO friends (name, phone, email, address, city, notes, max_loans) VALUES
('Anna Müller', '015112345678', 'anna.mueller@email.com', 'Hauptstraße 12, 10117', 'Berlin', 'Avid thriller reader.', 3),
('Lukas Schmidt', '015176543210', 'lukas.schmidt@email.com', 'Kantstraße 5, 20354', 'Hamburg', 'Big fan of Sci-Fi movies and books.', 3),
('Sophie Wagner', '016012345678', 'sophie.wagner@email.com', 'Goethestraße 88, 80331', 'München', 'Very careful with book covers.', 3),
('Maximilian Weber', '017212345678', 'max.weber@email.com', 'Schillerstraße 21, 50667', 'Köln', 'Loves classic literature.', 3),
('Laura Fischer', '015198765432', 'laura.fischer@email.com', 'Bahnhofstraße 3, 60311', 'Frankfurt am Main', 'Childhood friend, very reliable.', 3),
('Paul Schneider', '016298765432', 'paul.schneider@email.com', 'Ringweg 44, 70173', 'Stuttgart', 'History buff, especially WWII.', 3),
('Emma Becker', '017398765432', 'emma.becker@email.com', 'Lindenallee 7, 40213', 'Düsseldorf', 'Reads extremely fast.', 3),
('Leon Hoffmann', '015223344556', 'leon.hoffmann@email.com', 'Marktplatz 2, 44135', 'Dortmund', 'Tends to return books late.', 3),
('Mia Schulz', '016334455667', 'mia.schulz@email.com', 'Kirchplatz 15, 45127', 'Essen', 'Interested in modern philosophy.', 3),
('Noah Klein', '017445566778', 'noah.klein@email.com', 'Parkstraße 10, 04109', 'Leipzig', 'Always follows the bestseller list.', 3),
('Hannah Wolf', '015556677889', 'hannah.wolf@email.com', 'Waldweg 55, 28195', 'Bremen', 'Architect friend with an eye for design.', 3),
('Elias Neumann', '016667788990', 'elias.neumann@email.com', 'Rosenweg 12, 01067', 'Dresden', 'Art history student.', 3),
('Lina Schwarz', '017778899001', 'lina.schwarz@email.com', 'Bergstraße 9, 30159', 'Hannover', 'True romantic novel lover.', 3),
('Ben Zimmermann', '015889900112', 'ben.zimmermann@email.com', 'Talweg 33, 90403', 'Nürnberg', 'Former colleague from the office.', 3),
('Clara Braun', '016990011223', 'clara.braun@email.com', 'Gartenstraße 4, 47051', 'Duisburg', 'Into self-improvement books.', 3),
('Jonas Krüger', '017001122334', 'jonas.krueger@email.com', 'Feldstraße 22, 44787', 'Bochum', 'Borrows a lot of cookbooks.', 3),
('Lea Hartmann', '015112233445', 'lea.hartmann@email.com', 'Bachstraße 1, 42103', 'Wuppertal', 'Passion for poetry and lyrics.', 3),
('Felix Lange', '016223344556', 'felix.lange@email.com', 'Hochstraße 77, 33602', 'Bielefeld', 'Graphic novel collector.', 3),
('Nina Schmitt', '017334455667', 'nina.schmitt@email.com', 'Breiteweg 18, 53111', 'Bonn', 'University professor, very academic.', 3),
('Tim König', '015445566778', 'tim.koenig@email.com', 'Luisenstraße 9, 48143', 'Münster', 'Spends most of his time in libraries.', 3),
('Anke Kreis', '015011114511', 'anke.kreis@email.com', 'Alexanderstr 45', 'Berlin', 'Loves fantasy books', 3),
('Oleh Igikai', '071022278922', 'oleh.igikai@gmail.com', 'Hauptgasse 65', 'Munich', 'Returns books late sometimes', 3),
('Mario Freid', '015137433333', 'mario.freid@email.com', 'Elbstrasse 8', 'Hamburg', 'Returns books late sometimes', 3),
('John Greys', '051044446244', 'john.greys@email.com', 'Domstrasse 3', 'Cologne', 'Loves thrillers', 3),
('Emma Brown', '015055665545', 'emma.brown@gmail.com', 'Mainzer Landstrasse 15', 'Frankfurt', 'Prefers biographies', 3),
('Lukas Schneebart', '015066621366', 'lukas.schneebart@gmail.com', 'Bahnstrasse 27', 'Stuttgart', 'Enjoys sci-fi novels', 3),
('Sophie Sagner', '015077789577', 'sophie.sagner@email.com', 'Ringstrasse 7', 'Düsseldorf', 'Prefers biographies', 3),
('Maximilian Becker', '015086928888', 'max.becker@email.com', 'Goethestrasse 27', 'Leipzig', 'Reads historical books', 3),
('Laura Hoffs', '015099941009', 'laura.hoffs@gmail.com', 'Marktplatz 5', 'Dresden', 'Reads scientific books', 3),
('Daniel Weffer', '015012345600', 'daniel.weffer@email.com', 'Kaiserstrasse 30', 'Bonn', 'Often borrows thrillers', 3),
('Alice Johnson', '+49 151 1234 5001', 'alice.johnson@gmail.com', 'Torstraße 1', 'Berlin', 'Loves fantasy books', 3),
('Ben Carter', '+49 152 2345 5002', 'ben.carter@yahoo.com', 'HafenCity 4', 'Hamburg', 'Returns books on time', 3),
('Clara Schmidt', '+49 153 3456 5003', 'clara.schmidt@gmail.com', 'Sendlinger Str. 12', 'Munich', 'Interested in classics', 3),
('David Müller', '+49 154 4567 5004', 'david.mueller@web.de', 'Hohe Straße 8', 'Cologne', 'Prefers audiobooks', 3),
('Elena Petrov', '+49 155 5678 5005', 'elena.petrov@mail.ru', 'Zeil 102', 'Frankfurt', 'Russian literature fan', 3),
('Frank Weber', '+49 156 6789 5006', 'frank.weber@gmx.de', 'Königstraße 5', 'Stuttgart', 'Sci-fi enthusiast', 3),
('Grace Kim', '+49 157 7890 5007', 'grace.kim@gmail.com', 'Schadowstraße 15', 'Düsseldorf', 'Reads during commute', 3),
('Hans Becker', '+49 158 8901 5008', 'hans.becker@t-online.de', 'Grimmaische Str. 2', 'Leipzig', 'History buff', 3),
('Ines Fischer', '+49 159 9012 5009', 'ines.fischer@gmail.com', 'Prager Straße 44', 'Dresden', 'Philosophy reader', 3),
('Jake Wilson', '+49 151 0123 5010', 'jake.wilson@outlook.com', 'Sögestraße 21', 'Bremen', 'Thriller lover', 3),
('Kira Nowak', '+49 152 1234 5011', 'kira.nowak@gmail.com', 'Lister Meile 7', 'Hannover', 'Reads 2-3 books a month', 3),
('Leo Braun', '+49 153 2345 5012', 'leo.braun@gmx.de', 'Karolinenstraße 10', 'Nürnberg', 'Biography fan', 3),
('Maya Hoffmann', '+49 154 3456 5013', 'maya.hoffmann@web.de', 'Königstraße 2', 'Duisburg', 'Loves mystery novels', 3),
('Nils Koch', '+49 155 4567 5014', 'nils.koch@gmail.com', 'Kortumstraße 55', 'Bochum', 'Keeps books in good shape', 3),
('Olga Ivanova', '+49 156 5678 5015', 'olga.ivanova@mail.ru', 'Friedrich-Ebert-Str. 1', 'Wuppertal', 'Classic literature only', 3),
('Paul Schulz', '+49 157 6789 5016', 'paul.schulz@gmail.com', 'Bahnhofstraße 12', 'Bielefeld', 'Crime fiction reader', 3),
('Quinn Adams', '+49 158 7890 5017', 'quinn.adams@outlook.com', 'Sternstraße 8', 'Bonn', 'Reads before bed', 3),
('Rosa Huber', '+49 159 8901 5018', 'rosa.huber@gmx.de', 'Ludgeristraße 102', 'Münster', 'Recommends books actively', 3),
('Sam Wolf', '+49 151 9012 5019', 'sam.wolf@gmail.com', 'Friedrichstraße 19', 'Berlin', 'Romance and drama', 3),
('Tina Richter', '+49 152 0123 5020', 'tina.richter@web.de', 'Mönckebergstraße 7', 'Hamburg', 'Self-help and psychology', 3),
('Uwe Klein', '+49 153 1234 5021', 'uwe.klein@t-online.de', 'Viktualienmarkt 3', 'Munich', 'Economics and business', 3),
('Vera Lange', '+49 154 2345 5022', 'vera.lange@gmail.com', 'Schildergasse 44', 'Cologne', 'Young adult fiction', 3),
('Walt Krause', '+49 155 3456 5023', 'walt.krause@gmx.de', 'Eschersheimer Landstr. 20', 'Frankfurt', 'War novels and memoirs', 3),
('Xena Fuchs', '+49 156 4567 5024', 'xena.fuchs@outlook.com', 'Schloßstraße 12', 'Stuttgart', 'Fantasy and magic', 3),
('Yara Zimmermann', '+49 157 5678 5025', 'yara.zimmermann@gmail.com', 'Königsallee 55', 'Düsseldorf', 'Travel literature', 3),
('Zach Wagner', '+49 158 6789 0125', 'zach.wagner@web.de', 'Augustusplatz 1', 'Leipzig', 'Horror and dark fiction', 3),
('Anna Schwarz', '+49 159 7890 5027', 'anna.schwarz@gmail.com', 'Wilsdruffer Str. 10', 'Dresden', 'Graphic novels fan', 3),
('Boris Lehmann', '+49 151 8901 5028', 'boris.lehmann@gmx.de', 'Obernstraße 14', 'Bremen', 'Poetry and prose', 3),
('Cara Hartmann', '+49 152 9012 5029', 'cara.hartmann@gmail.com', 'Georgstraße 3', 'Hannover', 'Dystopian fiction', 3),
('Denis Meier', '+49 153 0123 5030', 'denis.meier@outlook.com', 'Königstraße 22', 'Nürnberg', 'Data and tech books', 3);

SELECT * FROM books ORDER BY id DESC;