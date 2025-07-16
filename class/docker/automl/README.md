# AutoML Jupyter 환경

Python 3.11 기반의 주피터 노트북 환경입니다. AutoML과 머신러닝 작업을 위한 다양한 라이브러리가 설치되어 있습니다.

## 설치된 패키지

- **AutoML**: pycaret
- **머신러닝**: scikit-learn, lightgbm, catboost, xgboost
- **데이터 처리**: pandas, numpy
- **시각화**: plotly, matplotlib, seaborn
- **기타**: tqdm, requests

## 사용법

### 1. 컨테이너 빌드 및 실행

```bash
# 컨테이너 빌드 및 실행
docker-compose up --build

# 백그라운드에서 실행
docker-compose up -d --build
```

### 2. 주피터 노트북 접속

브라우저에서 다음 URL로 접속:
```
http://localhost:8888
```

### 3. 컨테이너 중지

```bash
docker-compose down
```

## 디렉토리 구조

```
docker/automl/
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── README.md
├── notebooks/          # 주피터 노트북 파일들
└── data/              # 데이터 파일들
```

## 볼륨 마운트

- `./notebooks` → `/workspace/notebooks`: 주피터 노트북 파일들
- `./data` → `/workspace/data`: 데이터 파일들

## 포트

- **8888**: 주피터 노트북 서버

## 주의사항

- 컨테이너를 처음 실행할 때 패키지 설치로 인해 시간이 걸릴 수 있습니다.
- 노트북 파일은 `notebooks/` 디렉토리에 저장하면 호스트와 공유됩니다.
- 데이터 파일은 `data/` 디렉토리에 저장하면 호스트와 공유됩니다. 