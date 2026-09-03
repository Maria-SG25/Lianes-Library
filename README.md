# Lianes Library 📚

A streamlined, relational database-backed Python application designed to solve a classic problem: keeping track of borrowed books, managing collections, and ensuring avid readers never lose track of their favorite volumes again.

---

### 🚀 Overview
**Liane's Library** is built to transition an overwhelming, manual book collection into an organized, digital personal catalog. It leverages a clean relational schema to manage books, borrowers, and active loans seamlessly, ensuring data integrity and effortless retrieval.

---

### 🛠️ Technical Stack & Tools
* **Language & Core:** Python 3.12, Pandas
* **Database & ORM:** MySQL / Relational Database Design, SQLAlchemy, PyMySQL
* **App Interface:** Streamlit 
* **Environment Management:** Conda (`conda-forge`)
* **Version Control:** Git / GitHub

---

### 📐 Database Architecture
The application relies on a normalized relational database (`lianes_library`) structured around three core tables:
1. **`books` Table:** Stores unique metadata (title, author, genre) and tracks real-time availability status.
2. **`borrowers` Table:** Keeps contact information for friends, colleagues, and acquaintances within six degrees of separation.
3. **`loans` Table:** Implements foreign keys to maintain transactional history, recording borrow dates, return dates, and active loan statuses.

---

### ⚙️ Features
* **Inventory Management:** Easily catalog books with duplicate prevention via unique identifiers.
* **Loan Tracking:** Record who borrowed which book, when it left, and when it needs to be returned.
