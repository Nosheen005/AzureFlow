import streamlit as st
from connect_data_warehouse import query_job_listings
import altair as alt
import pandas as pd

# Order for charts
def order_by_vacancies(df, col):
    df = df.sort_values("VACANCIES", ascending=False)
    df[col] = pd.Categorical(df[col], categories=df[col], ordered=True)
    return df

st.set_page_config(layout="wide")

page1 = st.sidebar.radio("Meny", ["Start", "Annonser"])
page2 = st.sidebar.radio('Data', ['Bygg och anläggning', 'Data/IT', 'Administration, ekonomi, juridik'])

def layout_graphs(df: pd.DataFrame, mart: str, name: str):
    st.title(f"{name}-annonser")
    st.write("En dashboard som visar annonser från arbetsförmedlingens API.")

    cols = st.columns(2)
    with cols[0]:
        st.metric(label="Total vacancies", value=df["VACANCIES"].sum())
    with cols[1]:
        st.metric(label="Total ads", value=len(df))

    df_employer = query_job_listings(f"""
        SELECT SUM(VACANCIES) AS VACANCIES, EMPLOYER_NAME
        FROM {mart}
        GROUP BY EMPLOYER_NAME
        ORDER BY VACANCIES DESC
        LIMIT 10
    """)
    df_occupation = query_job_listings(f"""
        SELECT SUM(VACANCIES) AS VACANCIES, OCCUPATION
        FROM {mart}
        GROUP BY OCCUPATION
        ORDER BY VACANCIES DESC
        LIMIT 10
    """)
    df_region = query_job_listings(f"""
        SELECT SUM(VACANCIES) AS VACANCIES, WORKPLACE_REGION
        FROM {mart}
        GROUP BY WORKPLACE_REGION
        ORDER BY VACANCIES DESC
        LIMIT 10
    """)
    df_duration = query_job_listings(f"""
        SELECT SUM(VACANCIES) AS VACANCIES, DURATION
        FROM {mart}
        GROUP BY DURATION
        ORDER BY VACANCIES DESC
        LIMIT 10
    """)

    df_employer = order_by_vacancies(df_employer, "EMPLOYER_NAME")
    df_occupation = order_by_vacancies(df_occupation, "OCCUPATION")
    df_region = order_by_vacancies(df_region, "WORKPLACE_REGION")
    df_duration = order_by_vacancies(df_duration, "DURATION")

    cols = st.columns(2)
    with cols[0]:
        st.write("### Top 10 Employers by Vacancies")
        st.write(alt.Chart(df_employer).mark_bar().encode(
            x=alt.X("EMPLOYER_NAME", title="Employer"),
            y=alt.Y("VACANCIES", title="Vacancies"),
            color=alt.Color("EMPLOYER_NAME:N", legend=None),
            tooltip=["EMPLOYER_NAME", "VACANCIES"]
        ))

    with cols[1]:
        st.write("### Top 10 Occupations by Vacancies")
        st.write(alt.Chart(df_occupation).mark_bar().encode(
            x=alt.X("OCCUPATION", title="Occupation"),
            y=alt.Y("VACANCIES", title="Vacancies"),
            color=alt.Color("OCCUPATION:N", legend=None),
            tooltip=["OCCUPATION", "VACANCIES"]
        ))

    cols = st.columns(2)
    with cols[0]:
        st.write("### Top 10 Regions by Vacancies")
        st.write(alt.Chart(df_region).mark_bar().encode(
            x=alt.X("WORKPLACE_REGION", title="Region"),
            y=alt.Y("VACANCIES", title="Vacancies"),
            color=alt.Color("WORKPLACE_REGION:N", legend=None),
            tooltip=["WORKPLACE_REGION", "VACANCIES"]
        ))
    with cols[1]:
        st.write("### Duration of employment by Vacancies")
        st.write(alt.Chart(df_duration).mark_bar().encode(
            x=alt.X("DURATION", title="Duration"),
            y=alt.Y("VACANCIES", title="Vacancies"),
            color=alt.Color("DURATION:N", legend=None),
            tooltip=["DURATION", "VACANCIES"]
        ))

def layout_ads(df: pd.DataFrame):
#    expected = [
#        "WORKPLACE_REGION","OCCUPATION","EMPLOYER_NAME","HEADLINE",
#        "DESCRIPTION_HTML","VACANCIES","APPLICATION_DEADLINE",
#        "DURATION","EMPLOYMENT_TYPE","SALARY_TYPE",
#        "JOB_DESCRIPTION_ID","OCCUPATION_GROUP"
#    ]
#    missing = [c for c in expected if c not in df.columns]
#    if missing:
#        st.error(f"Saknade kolumner: {missing}")
#        return

    cols = st.columns(4)
    with cols[0]:
        select_region = st.selectbox(
            "Select region:", 
            df["WORKPLACE_REGION"].unique())
    with cols[1]:
        select_occupation = st.selectbox(
            "Select occupation:",
            df.query("WORKPLACE_REGION == @select_region")["OCCUPATION"].unique()
        )
    with cols[2]:
        select_company = st.selectbox(
            "Select company:",
            df.query("WORKPLACE_REGION == @select_region & OCCUPATION == @select_occupation")["EMPLOYER_NAME"].unique()
        )
    with cols[3]:
        select_headline = st.selectbox(
            "Select headline:",
            df.query("WORKPLACE_REGION == @select_region & OCCUPATION == @select_occupation & EMPLOYER_NAME == @select_company")["HEADLINE"]
        )

    sel = df.query(
        "WORKPLACE_REGION == @select_region & OCCUPATION == @select_occupation & EMPLOYER_NAME == @select_company & HEADLINE == @select_headline"
    )
#    if sel.empty:
#        st.warning("Ingen träff på det urvalet.")
#        return

    row = sel.iloc[0]
    st.markdown("## Job listings data")
    st.markdown(row["DESCRIPTION_HTML"], unsafe_allow_html=True)

    st.write(""); st.write(""); st.write(""); st.write(""); st.write(""); st.write("")

    cols = st.columns(4)
    with cols[0]:
        st.markdown("<h4 style='color:steelblue'> Vacancies </h4>", unsafe_allow_html=True)
        st.markdown(f"{row['VACANCIES']}")
    with cols[1]:
        st.markdown("<h4 style='color:steelblue'> Application deadline </h4>", unsafe_allow_html=True)
        st.markdown(f"{row['APPLICATION_DEADLINE']}")
    with cols[2]:
        st.markdown("<h4 style='color:steelblue'> Duration </h4>", unsafe_allow_html=True)
        st.markdown(f"{row['DURATION']}")
    with cols[3]:
        st.markdown("<h4 style='color:steelblue'> Employment type </h4>", unsafe_allow_html=True)
        st.markdown(f"{row['EMPLOYMENT_TYPE']}")

    cols = st.columns(4)
    with cols[0]:
        st.markdown("<h4 style='color:steelblue'> Salary type </h4>", unsafe_allow_html=True)
        st.markdown(f"{row['SALARY_TYPE']}")
    with cols[1]:
        st.markdown("<h4 style='color:steelblue'> Job ID </h4>", unsafe_allow_html=True)
        st.markdown(f"{row['JOB_DESCRIPTION_ID']}")
    with cols[2]:
        st.markdown("<h4 style='color:steelblue'> Occupation group </h4>", unsafe_allow_html=True)
        st.markdown(f"{row['OCCUPATION_GROUP']}")


if page2 == "Bygg och anläggning":
    df_test = query_job_listings('SELECT * FROM marts.mart_construction')
    mart = "marts.mart_construction"
    name = "Bygg och anläggning"
elif page2 == "Data/IT":
    df_test = query_job_listings('SELECT * FROM marts.mart_it')
    mart = "marts.mart_it"
    name = "Data/IT"
elif page2 == "Administration, ekonomi, juridik":
    df_test = query_job_listings('SELECT * FROM marts.mart_economics')
    mart = "marts.mart_economics"
    name = "Administration, ekonomi, juridik"

# Routing
if page1 == "Start":
    layout_graphs(df_test, mart, name)
elif page1 == "Annonser":
    layout_ads(df_test)
