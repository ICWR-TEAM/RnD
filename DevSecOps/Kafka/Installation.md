# Kafka Installation

## Docker

### Install and Running

Get Kafka with GIT

```bash
git clone https://github.com/conduktor/kafka-stack-docker-compose.git
```

<img width="569" alt="image" src="https://github.com/user-attachments/assets/045cfbd6-7f72-46d7-99e5-a7322199969c" />

Command Run

```bash
cd kafka-stack-docker-compose
docker-compose -f zk-single-kafka-single.yml up -d
```

<img width="1354" alt="image" src="https://github.com/user-attachments/assets/610fc1ef-01fd-437d-b08e-749634250131" />

Check service is running

```bash
docker-compose -f zk-single-kafka-single.yml ps
```

<img width="1389" alt="image" src="https://github.com/user-attachments/assets/d122f162-8ac6-4c4f-ba13-256dad3f9d26" />


### Stop Kafka

```bash
docker-compose -f zk-single-kafka-single.yml stop
docker-compose -f zk-single-kafka-single.yml down
```

<img width="1326" alt="image" src="https://github.com/user-attachments/assets/4b12cd76-b0ae-41e3-a933-eb9ec9e7d547" />
