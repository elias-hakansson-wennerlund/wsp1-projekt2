PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  picture_id INTEGER,
  first_name TEXT NOT NULL,
  last_name TEXT,
  phone TEXT NOT NULL,
  email TEXT,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
  FOREIGN KEY (picture_id) REFERENCES media(id),
);

CREATE TABLE contacts (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  picture_id INTEGER,
  first_name TEXT NOT NULL,
  last_name TEXT,
  company TEXT,
  phone_number TEXT,
  email TEXT,
  birthday DATE,
  note TEXT,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (picture_id) REFERENCES media(id),
);

CREATE TABLE media (
  id INTEGER PRIMARY KEY,
  url TEXT NOT NULL,
  file_type TEXT NOT NULL,
  file_name TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);
