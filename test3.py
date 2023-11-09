import requests

# Mengirimkan permintaan GET ke API
url = "https://berita-indo-api-next.vercel.app/api/cnn-news/teknologi"
response = requests.get(url)

# Mendapatkan data JSON dari respons API
json_data = response.json()

# Menampilkan data JSON
print(json_data)

import pandas as pd

# Mengambil nilai dari kunci 'data' dalam JSON
data = json_data['data']

# Membuat DataFrame dari data JSON
df = pd.DataFrame(data)

# Transformasi kolom 'isoDate' menjadi tipe data datetime
df['isoDate'] = pd.to_datetime(df['isoDate'])

# Menampilkan DataFrame
print(df)


