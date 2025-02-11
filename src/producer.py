from kafka import KafkaProducer
from kafka.admin import KafkaAdminClient, NewTopic
import json
from datetime import datetime
import time

 # 새로운 토픽을 생성하는 함수
def create_kafka_topic(bootstrap_servers, topic_name, num_partitions, replication_factor):
    admin_client = KafkaAdminClient(
        bootstrap_servers=bootstrap_servers,
        client_id='producer_client'
    )
    
    # 새 토픽 정의
    topic_list = [
        NewTopic(name=topic_name, num_partitions=num_partitions, replication_factor=replication_factor)
    ]

    # 토픽 생성 요청
    try:
        existing_topics = admin_client.list_topics()

        if topic_name in existing_topics:
            print(f"Topic '{topic_name}' already exists.")
            return

        admin_client.create_topics(new_topics=topic_list, validate_only=False)
        print(f"Topic '{topic_name}' created successfully.")

    except Exception as e:
        print(f"Failed to create topic '{topic_name}': {e}")

    finally:
        admin_client.close()

# JSON 데이터를 직렬화하는 함수
def json_serializer(data):
    return json.dumps(data).encode('utf-8')

# kafka 외부 ip 
KAFKA_NODE1_EXTERNAL_IP = None 

bootstrap_servers = ['{KAFKA_NODE1_EXTERNAL_IP}:29092'] 
topic_name = "test-topic3"
num_partitions = 1
replication_factor = 2

# Kafka Producer 설정
producer = KafkaProducer(
    bootstrap_servers=bootstrap_servers,  # Kafka 서버 주소
    value_serializer=json_serializer     # JSON 직렬화 함수
)

# 토픽 생성
create_kafka_topic(bootstrap_servers, topic_name, num_partitions, replication_factor)

i = 1 

try:
    while True:
        try:
            # 보낼 JSON 데이터
            data = {"time": str(datetime.now()),
                    "data": str(i)
                    }

            # "test-topic" 토픽에 JSON 데이터 보내기
            producer.send(topic_name, value=data).get(timeout=5)
            print("add", data)

            time.sleep(1)
            i += 1 

        except Exception as e:
            print(e)
            time.sleep(5)

finally:
    # Producer 종료
    producer.flush()
    producer.close()
    print('close Producer')