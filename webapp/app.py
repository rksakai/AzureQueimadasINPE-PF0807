import os
import pymysql
import folium
from flask import Flask, render_template_string

app = Flask(__name__)

HTML = """
<!DOCTYPE html>
<html>
<head>
    <title>Monitor de Queimadas</title>
    <style>
        body { font-family: sans-serif; margin: 20px; }
        h2   { color: #008542; }
        .info { background: #E8F5E9; padding: 10px; border-radius: 6px;
                display: inline-block; margin-bottom: 12px; }
    </style>
</head>
<body>
    <h2>Focos de Queimadas - Ultimas 24h</h2>
    <div class="info">Total de focos exibidos: <b>{{ total }}</b></div>
    {{ mapa | safe }}
</body>
</html>
"""

def get_connection():
    return pymysql.connect(
        host=os.environ["SQL_SERVER"],
        user=os.environ["SQL_USER"],
        password=os.environ["SQL_PASS"],
        database=os.environ["SQL_DB"],
        connect_timeout=30
    )

@app.route("/")
def index():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT lat, lon, municipio, estado, bioma
        FROM focos_queimadas
        ORDER BY coletado_em DESC
        LIMIT 500
    """)
    rows = cursor.fetchall()
    conn.close()

    mapa = folium.Map(location=[-15.0, -55.0], zoom_start=4)
    for lat, lon, municipio, estado, bioma in rows:
        if lat is not None and lon is not None:
            folium.CircleMarker(
                location=[lat, lon], radius=4,
                color="red", fill=True, fill_opacity=0.7,
                popup=folium.Popup(
                    f"<b>{municipio}</b> - {estado}<br>Bioma: {bioma}",
                    max_width=200
                )
            ).add_to(mapa)

    return render_template_string(HTML, mapa=mapa._repr_html_(), total=len(rows))

@app.route("/health")
def health():
    return {"status": "ok"}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=False)
