import streamlit as st
import mysql.connector
import pandas as pd
import base64
import time
from datetime import date

st.set_page_config(page_title="Liane's Library", page_icon="📚", layout="wide")

# ──────────────────────────────────────────────
# HELPERS
# ──────────────────────────────────────────────

def get_base64_of_bin_file(bin_file):
    try:
        with open(bin_file, "rb") as f:
            return base64.b64encode(f.read()).decode()
    except FileNotFoundError:
        return None

def get_db_connection():
    try:
        return mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="lianes_library",
            autocommit=True,
        )
    except Exception as err:
        st.error(f"❌ DB Connection Error: {err}")
        return None

def log_activity(book_title, borrower_name, action, b_id=None, f_id=None):
    conn = get_db_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(
                    "INSERT INTO activity_log (book_title, borrower_name, action_type, book_id, friend_id) "
                    "VALUES (%s,%s,%s,%s,%s)",
                    (book_title, borrower_name, action, b_id, f_id),
                )
        finally:
            conn.close()

def format_rating(val):
    if val is None or (isinstance(val, float) and pd.isna(val)):
        return "—"
    stars = max(1, min(5, round(int(val) / 2)))
    return "⭐" * stars

def show_table(df):
    st.dataframe(
        df.style.set_properties(**{
            "background-color": "#ffffff",
            "color": "#111111",
        }),
        use_container_width=True,
        hide_index=True,
    )

# ──────────────────────────────────────────────
# SESSION STATE & CSS
# ──────────────────────────────────────────────

if "page" not in st.session_state:
    st.session_state.page = "Welcome"

choice = st.session_state.page
IMG_PATH = "C:/projects/wbs_adv_sql/image_5.png"

LIGHT_CSS = """
<style>
.stApp { background-color: #faf4e9; }
body, p, span, label, div, li, a, .stMarkdown, .stText, [data-testid="stMarkdownContainer"], [data-testid="stMarkdownContainer"] *, .stForm label, .stForm p, [data-baseweb="label"], [data-baseweb="label"] *, .stSelectbox label, .stTextInput label, .stTextArea label, .stSlider label, .stNumberInput label { color: #1a1a1a !important; }
h1, h2, h3, h4, h5, h6 { color: #1a1a1a !important; }
.stTextInput > div > div > input, .stTextArea > div > div > textarea, .stNumberInput > div > div > input { background-color: #ffffff !important; color: #1a1a1a !important; border: 1px solid #cccccc !important; }
[data-baseweb="select"] > div, [data-baseweb="select"] > div > div, [data-baseweb="select"] input { background-color: #ffffff !important; color: #1a1a1a !important; }
[data-testid="stSidebar"] { background-color: #efdcbf; border-right: 1px solid rgba(0,0,0,0.1); }
[data-testid="stSidebar"] div.stButton > button { display: flex !important; justify-content: flex-start !important; text-align: left !important; padding-left: 15px !important; border: 2px solid #ffffff !important; background-color: #d1c09d !important; color: #ffffff !important; margin-bottom: 10px; border-radius: 8px !important; width: 100% !important; transition: all 0.3s ease; }
[data-testid="stSidebar"] div.stButton > button * { color: #ffffff !important; }
div.stButton > button { color: #ffffff !important; background-color: #d1c09d !important; border: 1px solid #b8a882 !important; border-radius: 8px !important; font-weight: 600 !important; transition: all 0.3s ease !important; }
</style>
"""

if choice == "Welcome":
    img_base64 = get_base64_of_bin_file(IMG_PATH)
    bg_style = f'background-image: url("data:image/png;base64,{img_base64}");' if img_base64 else "background-color: #0e1117;"
    st.markdown(f"""<style>.stApp {{ {bg_style} background-size: cover; background-position: center; background-repeat: no-repeat; background-attachment: fixed; }} header {{ visibility: hidden; }} [data-testid="stSidebar"] {{ visibility: hidden; }} .block-container {{ padding: 0rem; }} div.stButton > button {{ position: fixed; bottom: 40px; right: 40px; width: auto !important; background-color: #d1c09d !important; color: #ffffff !important; border: 1px solid #ffffff !important; border-radius: 5px !important; padding: 12px 30px !important; font-size: 20px !important; font-weight: 600 !important; box-shadow: 0px 4px 15px rgba(0,0,0,0.4); z-index: 9999; transition: all 0.3s ease; }} div.stButton > button:hover {{ transform: scale(1.1); background-color: #e8d0ab !important; }}</style>""", unsafe_allow_html=True)
else:
    st.markdown(LIGHT_CSS, unsafe_allow_html=True)

# ──────────────────────────────────────────────
# SIDEBAR
# ──────────────────────────────────────────────

if choice != "Welcome":
    with st.sidebar:
        st.title("📌 Navigation")
        pages = [("📊", "Dashboard"), ("📚", "Books Management"), ("👥", "Friends Management"), ("📤", "Issue Loan"), ("📥", "Return Book"), ("📜", "Activity History")]
        for icon, name in pages:
            if st.button(f"{icon} {name}", use_container_width=True):
                st.session_state.page = name
                st.rerun()
        st.write("---")
        if st.button("🏠 Homepage", use_container_width=True):
            st.session_state.page = "Welcome"
            st.rerun()

# ──────────────────────────────────────────────
# PAGES
# ──────────────────────────────────────────────

if choice == "Welcome":
    if st.button("☕️ &nbsp; INTO THE LIBRARY"):
        st.session_state.page = "Dashboard"
        st.rerun()

elif choice == "Dashboard":
    st.title(f"Liane's Personal Library — {choice}")
    conn = get_db_connection()
    if conn:
        try:
            df = pd.read_sql("""
                SELECT b.isbn AS ISBN, b.title AS TITLE, b.author AS AUTHOR,
                       b.rating AS RATING, fr.name AS BORROWER, b.status AS STATUS
                FROM books b
                LEFT JOIN loans l ON b.id = l.book_id AND l.return_date IS NULL
                LEFT JOIN friends fr ON l.friend_id = fr.id
                """, conn)
        finally:
            conn.close()
        df["BORROWER"] = df["BORROWER"].fillna("—")
        df["RATING"] = df["RATING"].apply(format_rating)
        c1, c2, c3 = st.columns(3)
        card_html = """<div style="background-color:rgba(255,255,255,0.4);padding:25px;border-radius:15px;text-align:center;border-bottom:8px solid {color};box-shadow:2px 4px 10px rgba(0,0,0,0.05);"><div style="font-size:45px;margin-bottom:5px;">{icon}</div><div style="color:#444;font-size:18px;font-weight:700;text-transform:uppercase;margin-bottom:5px;">{label}</div><div style="font-size:32px;font-weight:900;color:#333;">{val}</div></div>"""
        c1.markdown(card_html.format(icon="📚", label="Total Books", val=len(df), color="#6c63ff"), unsafe_allow_html=True)
        c2.markdown(card_html.format(icon="🤝", label="Borrowed Books", val=len(df[df["STATUS"]=="Borrowed"]), color="#ff4b4b"), unsafe_allow_html=True)
        c3.markdown(card_html.format(icon="🏠", label="Available Books", val=len(df[df["STATUS"]=="Available"]), color="#28a745"), unsafe_allow_html=True)
        st.write("<br>", unsafe_allow_html=True)
        df["STATUS"] = df["STATUS"].apply(lambda x: "🏠 Available" if x == "Available" else "📤 Borrowed")
        show_table(df)

elif choice == "Books Management":
    st.title(f"Liane's Personal Library — {choice}")
    tab_view, tab_add = st.tabs(["📝 View & Edit", "➕ Add Book"])
    with tab_add:
        with st.form("add_book_form", clear_on_submit=True):
            t = st.text_input("Title"); a = st.text_input("Author"); g = st.text_input("Genre"); i = st.text_input("ISBN"); r = st.slider("Rating (1–10)", 1, 10, 5)
            if st.form_submit_button("Add Book"):
                if t:
                    conn = get_db_connection()
                    if conn:
                        try:
                            with conn.cursor() as cur:
                                cur.execute("INSERT INTO books (title, author, genre, isbn, rating) VALUES (%s,%s,%s,%s,%s)", (t, a, g, i, r))
                        finally: conn.close()
                        log_activity(t, "System", "BOOK_ADDED")
                        st.success("Book added!"); time.sleep(1); st.rerun()
                else: st.warning("Title is required.")
    with tab_view:
        conn = get_db_connection()
        if conn:
            try: df_b = pd.read_sql("SELECT id, isbn, title, author, rating, status FROM books ORDER BY title", conn)
            finally: conn.close()
            df_b.insert(0, "Select", False)
            edited_df = st.data_editor(df_b, hide_index=True, key="book_editor", use_container_width=True, column_config={"id": None})
            if st.button("🗑️ Delete Selected Book"):
                to_delete = edited_df[edited_df["Select"] == True]
                if not to_delete.empty:
                    conn_del = get_db_connection()
                    if conn_del:
                        try:
                            with conn_del.cursor() as cur:
                                for _, row in to_delete.iterrows():
                                    cur.execute("DELETE FROM loans WHERE book_id = %s", (int(row["id"]),))
                                    cur.execute("DELETE FROM books WHERE id = %s", (int(row["id"]),))
                        finally: conn_del.close()
                        for _, row in to_delete.iterrows(): log_activity(row["title"], "System", "BOOK_DELETED")
                        st.success("Deleted!"); time.sleep(1); st.rerun()

elif choice == "Friends Management":
    st.title(f"Liane's Personal Library — {choice}")
    tab_view, tab_add = st.tabs(["👥 View Friends", "➕ Add Friend"])
    with tab_add:
        with st.form("add_friend_form", clear_on_submit=True):
            name = st.text_input("Name"); email = st.text_input("Email"); phone = st.text_input("Phone"); city = st.text_input("City")
            max_l = st.number_input("Max Loans Allowed", min_value=1, max_value=20, value=3)
            notes = st.text_area("Notes")
            if st.form_submit_button("Add Friend"):
                if name:
                    conn = get_db_connection()
                    if conn:
                        try:
                            with conn.cursor() as cur:
                                cur.execute("INSERT INTO friends (name, email, phone, city, max_loans, notes) VALUES (%s,%s,%s,%s,%s,%s)", (name, email, phone, city, max_l, notes))
                        finally: conn.close()
                        st.success("Friend added!"); time.sleep(1); st.rerun()
                else: st.warning("Name is required.")
    with tab_view:
        conn = get_db_connection()
        if conn:
            try:
                # ВЫЧИСЛЯЕМ ОСТАТОК (Remaining) прямо в SQL
                query = """
                    SELECT f.id, f.name, f.email, f.city, f.max_loans,
                           (SELECT COUNT(*) FROM loans l WHERE l.friend_id = f.id AND l.return_date IS NULL) as current_loans,
                           (f.max_loans - (SELECT COUNT(*) FROM loans l WHERE l.friend_id = f.id AND l.return_date IS NULL)) as remaining
                    FROM friends f ORDER BY f.name
                """
                df_f = pd.read_sql(query, conn)
            finally: conn.close()
            df_f.insert(0, "Select", False)
            st.data_editor(df_f, hide_index=True, key="friend_editor", use_container_width=True, 
                column_config={
                    "id": None,
                    "max_loans": "Total Limit",
                    "current_loans": "Books Held",
                    "remaining": st.column_config.ProgressColumn("Availability", help="Remaining loan slots", min_value=0, max_value=3, format="%d left")
                }
            )
            if st.button("🗑️ Delete Selected Friend"):
                # ... (код удаления)
                st.info("Select a row in the table and click delete.")

elif choice == "Issue Loan":
    st.title(f"Liane's Personal Library — {choice}")
    conn = get_db_connection()
    if conn:
        try:
            available_books = pd.read_sql("SELECT id, title, author FROM books WHERE status = 'Available' ORDER BY title", conn)
            # Считаем остаток для выпадающего списка
            friends = pd.read_sql("""
                SELECT id, name, max_loans,
                       (max_loans - (SELECT COUNT(*) FROM loans l WHERE l.friend_id = friends.id AND l.return_date IS NULL)) as rem
                FROM friends ORDER BY name
            """, conn)
        finally: conn.close()

        if available_books.empty: st.info("No available books.")
        elif friends.empty: st.info("No friends found.")
        else:
            with st.form("issue_loan_form"):
                book_options = {f"{r['title']} — {r['author']}": r["id"] for _, r in available_books.iterrows()}
                # Показываем сколько осталось мест в скобках
                friend_options = {f"{r['name']} ({r['rem']}/{r['max_loans']} left)": r for _, r in friends.iterrows()}
                
                selected_book = st.selectbox("Select Book", list(book_options.keys()))
                selected_friend_label = st.selectbox("Select Friend", list(friend_options.keys()))

                if st.form_submit_button("📤 Issue Loan"):
                    friend_data = friend_options[selected_friend_label]
                    if friend_data['rem'] <= 0:
                        st.error(f"❌ {friend_data['name']} reached the limit!")
                    else:
                        book_id = book_options[selected_book]
                        conn2 = get_db_connection()
                        if conn2:
                            try:
                                with conn2.cursor() as cur:
                                    cur.execute("INSERT INTO loans (book_id, friend_id, loan_date) VALUES (%s,%s,CURDATE())", (book_id, friend_data['id']))
                                    cur.execute("UPDATE books SET status = 'Borrowed' WHERE id = %s", (book_id,))
                            finally: conn2.close()
                            log_activity(selected_book, friend_data['name'], "LOAN_ISSUED", book_id, friend_data['id'])
                            st.success("Success!"); time.sleep(1); st.rerun()

elif choice == "Return Book":
    st.title(f"Liane's Personal Library — {choice}")
    conn = get_db_connection()
    if conn:
        try:
            active_loans = pd.read_sql("""
                SELECT l.id AS loan_id, b.id AS book_id, b.title, fr.id AS friend_id, fr.name AS borrower FROM loans l 
                JOIN books b ON l.book_id = b.id JOIN friends fr ON l.friend_id = fr.id WHERE l.return_date IS NULL
            """, conn)
        finally: conn.close()
        if not active_loans.empty:
            with st.form("return_form"):
                loan_map = {f"{r['title']} (to {r['borrower']})": r for _, r in active_loans.iterrows()}
                selected = st.selectbox("Select Book to Return", list(loan_map.keys()))
                if st.form_submit_button("📥 Return"):
                    r = loan_map[selected]
                    conn2 = get_db_connection()
                    if conn2:
                        try:
                            with conn2.cursor() as cur:
                                cur.execute("UPDATE loans SET return_date = CURDATE() WHERE id = %s", (r['loan_id'],))
                                cur.execute("UPDATE books SET status = 'Available' WHERE id = %s", (r['book_id'],))
                        finally: conn2.close()
                        log_activity(r['title'], r['borrower'], "BOOK_RETURNED", r['book_id'], r['friend_id'])
                        st.success("Returned!"); time.sleep(1); st.rerun()
        else: st.info("No active loans.")

elif choice == "Activity History":
    st.title("📜 Activity History")
    conn = get_db_connection()
    if conn:
        try: df_log = pd.read_sql("SELECT action_date, action_type, book_title, borrower_name FROM activity_log ORDER BY action_date DESC", conn)
        finally: conn.close()
        show_table(df_log)