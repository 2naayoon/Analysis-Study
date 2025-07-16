# 지도 파인튜닝 (SFT, Supervised Fine-Tuning)

예시 입력과 알려진 좋은 출력을 사용하여 모델을 파인튜닝합니다.

지도 파인튜닝(SFT)을 사용하면 특정 사용 사례에 대한 예시로 OpenAI 모델을 훈련할 수 있습니다. 그 결과 원하는 스타일과 콘텐츠를 더 안정적으로 생성하는 맞춤형 모델이 만들어집니다.

## 개요

지도 파인튜닝은 네 가지 주요 부분으로 구성됩니다:

1.  훈련 데이터셋을 구축하여 "좋은" 것이 무엇인지 결정합니다.
2.  예시 프롬프트와 원하는 모델 출력이 포함된 훈련 데이터셋을 업로드합니다.
3.  훈련 데이터를 사용하여 기본 모델에 대한 파인튜닝 작업을 생성합니다.
4.  파인튜닝된 모델을 사용하여 결과를 평가합니다.

**중요: 먼저 좋은 평가부터!** 평가를 설정한 후에만 파인튜닝에 투자하세요. 파인튜닝된 모델이 기본 모델보다 더 나은 성능을 보이는지 판단할 신뢰할 수 있는 방법이 필요합니다.

[평가 설정하기 →](https://platform.openai.com/docs/guides/evals)

## 데이터셋 구축

파인튜닝된 모델에서 유용한 결과를 얻으려면 강력하고 대표적인 데이터셋을 구축하세요. 다음 기술과 고려 사항을 사용하세요.

### 적절한 예시 수

*   파인튜닝을 위해 제공할 수 있는 최소 예시 수는 10개입니다.
*   50–100개의 예시에서 파인튜닝 개선 효과를 보았지만, 적절한 수는 사용 사례에 따라 크게 다릅니다.
*   50개의 잘 만들어진 데모로 시작하여 [결과를 평가](https://platform.openai.com/docs/guides/evals)하는 것을 권장합니다.

50개의 좋은 예시로 성능이 향상되면 예시를 추가하여 추가 결과를 확인해 보세요. 50개의 예시가 효과가 없다면 훈련 데이터를 추가하기 전에 작업이나 프롬프트를 다시 생각해 보세요.

### 좋은 예시란?

*   애플리케이션에서 기대하는 가능한 한 현실적인 프롬프트와 출력
*   구체적이고 명확한 질문과 답변
*   과거 데이터, 전문가 데이터, 기록된 데이터 또는 [수집된 다른 유형의 데이터](https://platform.openai.com/docs/guides/evals) 사용

### 데이터 포맷팅

*   [JSONL 형식](https://jsonlines.org/)을 사용하며, 훈련 데이터 파일의 모든 줄에 완전한 JSON 구조 하나를 포함합니다.
*   [채팅 완료 형식](https://platform.openai.com/docs/api-reference/fine-tuning/chat-input)을 사용합니다.
*   파일에는 최소 10줄이 있어야 합니다.

#### JSONL 형식 예시 파일

모델이 `get_weather` 함수를 호출하는 JSONL 훈련 데이터의 예시입니다:

```text
{"messages":[{"role":"user","content":"What is the weather in San Francisco?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\": \"San Francisco, USA\", \"format\": \"celsius\"}"}}]}],"parallel_tool_calls":false,"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country, eg. San Francisco, USA"},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
{"messages":[{"role":"user","content":"What is the weather in Minneapolis?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\": \"Minneapolis, USA\", \"format\": \"celsius\"}"}}]}],"parallel_tool_calls":false,"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country, eg. Minneapolis, USA"},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
{"messages":[{"role":"user","content":"What is the weather in San Diego?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\": \"San Diego, USA\", \"format\": \"celsius\"}"}}]}],"parallel_tool_calls":false,"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country, eg. San Diego, USA"},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
{"messages":[{"role":"user","content":"What is the weather in Memphis?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\": \"Memphis, USA\", \"format\": \"celsius\"}"}}]}],"parallel_tool_calls":false,"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country, eg. Memphis, USA"},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
{"messages":[{"role":"user","content":"What is the weather in Atlanta?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\": \"Atlanta, USA\", \"format\": \"celsius\"}"}}]}],"parallel_tool_calls":false,"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country, eg. Atlanta, USA"},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
{"messages":[{"role":"user","content":"What is the weather in Sunnyvale?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\": \"Sunnyvale, USA\", \"format\": \"celsius\"}"}}]}],"parallel_tool_calls":false,"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country, eg. Sunnyvale, USA"},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
{"messages":[{"role":"user","content":"What is the weather in Chicago?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\": \"Chicago, USA\", \"format\": \"celsius\"}"}}]}],"parallel_tool_calls":false,"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country, eg. Chicago, USA"},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
{"messages":[{"role":"user","content":"What is the weather in Boston?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\": \"Boston, USA\", \"format\": \"celsius\"}"}}]}],"parallel_tool_calls":false,"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country, eg. Boston, USA"},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
{"messages":[{"role":"user","content":"What is the weather in Honolulu?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\": \"Honolulu, USA\", \"format\": \"celsius\"}"}}]}],"parallel_tool_calls":false,"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country, eg. Honolulu, USA"},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
{"messages":[{"role":"user","content":"What is the weather in San Antonio?"},{"role":"assistant","tool_calls":[{"id":"call_id","type":"function","function":{"name":"get_current_weather","arguments":"{\"location\": \"San Antonio, USA\", \"format\": \"celsius\"}"}}]}],"parallel_tool_calls":false,"tools":[{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The city and country, eg. San Antonio, USA"},"format":{"type":"string","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}]}
```

#### 해당 JSON 데이터

훈련 데이터 파일의 각 줄에는 다음과 같은 JSON 구조가 포함되어 있으며, 예시 사용자 프롬프트와 모델의 올바른 응답이 `assistant` 메시지로 포함됩니다.

```json
{
  "messages": [
    { "role": "user", "content": "What is the weather in San Francisco?" },
    {
      "role": "assistant",
      "tool_calls": [
        {
          "id": "call_id",
          "type": "function",
          "function": {
            "name": "get_current_weather",
            "arguments": "{\"location\": \"San Francisco, USA\", \"format\": \"celsius\"}"
          }
        }
      ]
    }
  ],
  "parallel_tool_calls": false,
  "tools": [
    {
      "type": "function",
      "function": {
        "name": "get_current_weather",
        "description": "Get the current weather",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {
                "type": "string",
                "description": "The city and country, eg. San Francisco, USA"
            },
            "format": { "type": "string", "enum": ["celsius", "fahrenheit"] }
          },
          "required": ["location", "format"]
        }
      }
    }
  ]
}
```

## 훈련 데이터 업로드

OpenAI에 예제 데이터셋을 업로드합니다. 우리는 이를 사용하여 모델의 가중치를 업데이트하고 데이터에 포함된 것과 같은 출력을 생성합니다.

텍스트 완성 외에도 모델이 [구조화된 JSON 출력](https://platform.openai.com/docs/guides/structured-outputs)이나 [함수 호출](https://platform.openai.com/docs/guides/function-calling)을 더 효과적으로 생성하도록 훈련할 수 있습니다.

### 버튼 클릭으로 데이터 업로드

1.  대시보드 > **[파인튜닝](https://platform.openai.com/finetune)**으로 이동합니다.
2.  **+ 생성**을 클릭합니다.
3.  **훈련 데이터**에서 JSONL 파일을 업로드합니다.

### API를 호출하여 데이터 업로드

아래 데이터가 `mydata.jsonl` 파일에 저장되어 있다고 가정하고, 다음 코드를 사용하여 OpenAI 플랫폼에 업로드할 수 있습니다. 업로드된 파일의 `purpose`가 `fine-tune`으로 설정되어 있는지 확인하세요:

```bash
curl https://api.openai.com/v1/files \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -F purpose="fine-tune" \
  -F file="@mydata.jsonl"
```

API에서 반환된 데이터에 업로드된 파일의 `id`를 기록해 두세요. 후속 API 요청에서 해당 파일 식별자가 필요합니다.

```json
{
  "object": "file",
  "id": "file-RCnFCYRhFDcq1aHxiYkBHw",
  "purpose": "fine-tune",
  "filename": "mydata.jsonl",
  "bytes": 1058,
  "created_at": 1746484901,
  "expires_at": null,
  "status": "processed",
  "status_details": null
}
```

## 파인튜닝 작업 생성

테스트 데이터가 업로드되면, [파인튜닝 작업을 생성](https://platform.openai.com/docs/api-reference/fine-tuning/create)하여 제공한 훈련 데이터를 사용해 기본 모델을 맞춤화합니다. 파인튜닝 작업을 생성할 때 다음을 지정해야 합니다:

*   파인튜닝에 사용할 기본 모델(`model`). OpenAI 모델 ID 또는 이전에 파인튜닝된 모델의 ID가 될 수 있습니다. [모델 문서](https://platform.openai.com/docs/models)에서 어떤 모델이 파인튜닝을 지원하는지 확인하세요.
*   훈련 파일(`training_file`) ID. 이전 단계에서 업로드한 파일입니다.
*   파인튜닝 방법(`method`). 모델을 맞춤화하는 데 사용할 파인튜닝 방법을 지정합니다. 지도 파인튜닝이 기본값입니다.

### 버튼 클릭으로 데이터 업로드

1.  위와 동일한 **+ 생성** 모달에서 필수 필드를 완료합니다.
2.  지도 파인튜닝을 방법으로 선택하고 훈련할 모델을 선택합니다.
3.  준비가 되면 **생성**을 클릭하여 작업을 시작합니다.

### API를 호출하여 데이터 업로드

[파인튜닝 API](https://platform.openai.com/docs/api-reference/fine-tuning)를 호출하여 지도 파인튜닝 작업을 생성합니다:

```bash
curl https://api.openai.com/v1/fine_tuning/jobs \                               
  -H "Content-Type: application/json" \     
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "training_file": "file-RCnFCYRhFDcq1aHxiYkBHw",
    "model": "gpt-4.1-nano-2025-04-14"
  }'
```

API는 진행 중인 파인튜닝 작업에 대한 정보로 응답합니다. 훈련 데이터의 크기에 따라 훈련 과정은 몇 분에서 몇 시간이 걸릴 수 있습니다. 특정 작업에 대한 업데이트를 위해 [API를 폴링](https://platform.openai.com/docs/api-reference/fine-tuning/retrieve)할 수 있습니다.

파인튜닝 작업이 완료되면 파인튜닝된 모델을 사용할 준비가 된 것입니다. 완료된 파인튜닝 작업은 다음과 같은 데이터를 반환합니다:

```json
{
  "object": "fine_tuning.job",
  "id": "ftjob-uL1VKpwx7maorHNbOiDwFIn6",
  "model": "gpt-4.1-nano-2025-04-14",
  "created_at": 1746484925,
  "finished_at": 1746485841,
  "fine_tuned_model": "ft:gpt-4.1-nano-2025-04-14:openai::BTz2REMH",
  "organization_id": "org-abc123",
  "result_files": [
    "file-9TLxKY2A8tC5YE1RULYxf6"
  ],
  "status": "succeeded",
  "validation_file": null,
  "training_file": "file-RCnFCYRhFDcq1aHxiYkBHw",
  "hyperparameters": {
    "n_epochs": 10,
    "batch_size": 1,
    "learning_rate_multiplier": 1
  },
  "trained_tokens": 1700,
  "error": {},
  "user_provided_suffix": null,
  "seed": 1935755117,
  "estimated_finish": null,
  "integrations": [],
  "metadata": null,
  "usage_metrics": null,
  "shared_with_openai": false,
  "method": {
    "type": "supervised",
    "supervised": {
      "hyperparameters": {
        "n_epochs": 10,
        "batch_size": 1,
        "learning_rate_multiplier": 1.0
      }
    }
  }
}
```

`fine_tuned_model` 속성을 주목하세요. 이것은 [응답](https://platform.openai.com/docs/api-reference/responses)이나 [채팅 완료](https://platform.openai.com/docs/api-reference/chat)에서 파인튜닝된 모델을 사용하여 API 요청을 할 때 사용할 모델 ID입니다.

다음은 파인튜닝된 모델 ID로 응답 API를 호출하는 예시입니다:

```bash
curl https://api.openai.com/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "model": "ft:gpt-4.1-nano-2025-04-14:openai::BTz2REMH",
    "input": "What is the weather like in Boston today?",
    "tools": [
      {
        "name": "get_current_weather",
        "description": "Get the current weather",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {
                "type": "string",
                "description": "The city and country, eg. San Francisco, USA"
            },
            "format": { "type": "string", "enum": ["celsius", "fahrenheit"] }
          },
          "required": ["location", "format"]
        }
      }
    ],
    "tool_choice": "auto"
  }'
```

## 결과 평가

아래 방법을 사용하여 파인튜닝된 모델의 성능을 확인하세요. 원하는 결과를 얻을 때까지 프롬프트, 데이터, 파인튜닝 작업을 필요에 따라 조정하세요. 파인튜닝의 가장 좋은 방법은 계속 반복하는 것입니다.

### 평가와 비교

파인튜닝된 모델이 원래 기본 모델보다 성능이 좋은지 확인하려면 [평가](https://platform.openai.com/docs/guides/evals)를 사용하세요. 파인튜닝 작업을 실행하기 전에 1단계에서 수집한 동일한 훈련 데이터셋에서 데이터를 분리해 두세요. 이 홀드아웃 데이터는 평가에 사용할 때 대조군 역할을 합니다. 훈련 데이터와 홀드아웃 데이터가 사용자 입력 유형과 모델 응답의 다양성 측면에서 거의 동일한지 확인하세요.

[평가 실행에 대해 더 알아보기](https://platform.openai.com/docs/guides/evals).

### 상태 모니터링

대시보드에서 또는 API에서 작업 ID를 폴링하여 파인튜닝 작업의 상태를 확인하세요.

#### UI에서 모니터링

1.  [파인튜닝 대시보드](https://platform.openai.com/finetune)로 이동합니다.
2.  모니터링할 작업을 선택합니다.
3.  상태, 체크포인트, 메시지, 메트릭을 검토합니다.

#### API 호출로 모니터링

이 curl 명령을 사용하여 파인튜닝 작업에 대한 정보를 가져옵니다:

```bash
curl https://api.openai.com/v1/fine_tuning/jobs/ftjob-uL1VKpwx7maorHNbOiDwFIn6 \
  -H "Authorization: Bearer $OPENAI_API_KEY"
```

작업에는 `fine_tuned_model` 속성이 포함되어 있으며, 이는 새로운 파인튜닝된 모델의 고유 ID입니다.

```json
{
  "object": "fine_tuning.job",
  "id": "ftjob-uL1VKpwx7maorHNbOiDwFIn6",
  "model": "gpt-4.1-nano-2025-04-14",
  "created_at": 1746484925,
  "finished_at": 1746485841,
  "fine_tuned_model": "ft:gpt-4.1-nano-2025-04-14:openai::BTz2REMH",
  "organization_id": "org-abc123",
  "result_files": [
    "file-9TLxKY2A8tC5YE1RULYxf6"
  ],
  "status": "succeeded",
  "validation_file": null,
  "training_file": "file-RCnFCYRhFDcq1aHxiYkBHw",
  "hyperparameters": {
    "n_epochs": 10,
    "batch_size": 1,
    "learning_rate_multiplier": 1
  },
  "trained_tokens": 1700,
  "error": {},
  "user_provided_suffix": null,
  "seed": 1935755117,
  "estimated_finish": null,
  "integrations": [],
  "metadata": null,
  "usage_metrics": null,
  "shared_with_openai": false,
  "method": {
    "type": "supervised",
    "supervised": {
      "hyperparameters": {
        "n_epochs": 10,
        "batch_size": 1,
        "learning_rate_multiplier": 1.0
      }
    }
  }
}
```

### 파인튜닝된 모델 사용해보기

새롭게 최적화된 모델을 사용해 평가해 보세요! 파인튜닝된 모델의 훈련이 끝나면 OpenAI 기본 모델처럼 [응답](https://platform.openai.com/docs/api-reference/responses) 또는 [채팅 완료](https://platform.openai.com/docs/api-reference/chat) API에서 해당 ID를 사용하세요.

#### Playground에서 모델 사용하기

1.  [대시보드](https://platform.openai.com/finetune)의 파인튜닝 작업으로 이동합니다.
2.  오른쪽 창에서 **출력 모델**로 이동하여 모델 ID를 복사합니다. `ft:…`로 시작해야 합니다.
3.  [Playground](https://platform.openai.com/playground)를 엽니다.
4.  **모델** 드롭다운 메뉴에 모델 ID를 붙여넣습니다. 여기서 생성한 다른 파인튜닝된 모델도 볼 수 있습니다.
5.  일부 프롬프트를 실행하고 파인튜닝된 모델의 성능을 확인하세요!

#### API 호출로 모델 사용하기

```bash
curl https://api.openai.com/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "model": "ft:gpt-4.1-nano-2025-04-14:openai::BTz2REMH",
    "input": "What is 4+4?"
  }'
```

### 필요한 경우 체크포인트 사용

체크포인트는 사용할 수 있는 모델입니다. 각 훈련 에포크가 끝날 때마다 전체 모델 체크포인트를 생성합니다. 파인튜닝된 모델이 초반에는 개선되다가 일반화 가능한 지식을 배우는 대신 데이터셋을 암기하는 경우, 즉 _과적합(overfitting)_이 발생하는 경우에 유용합니다. 체크포인트는 프로세스의 다양한 시점에서 맞춤형 모델의 버전을 제공합니다.

#### 대시보드에서 체크포인트 찾기

1.  [파인튜닝 대시보드](https://platform.openai.com/finetune)로 이동합니다.
2.  왼쪽 패널에서 조사할 작업을 선택합니다. 성공할 때까지 기다립니다.
3.  오른쪽 패널에서 체크포인트 목록으로 스크롤합니다.
4.  체크포인트 위로 마우스를 가져가면 Playground에서 실행할 수 있는 링크가 표시됩니다.
5.  Playground에서 프롬프트를 입력하여 체크포인트 모델의 동작을 테스트합니다.

#### API로 체크포인트 쿼리하기

1.  [작업 상태를 쿼리하여](https://platform.openai.com/docs/api-reference/fine-tuning/retrieve) 작업이 성공할 때까지 기다립니다.
2.  파인튜닝 작업 ID로 [체크포인트 엔드포인트를 쿼리하여](https://platform.openai.com/docs/api-reference/fine-tuning/list-checkpoints) 파인튜닝 작업에 대한 모델 체크포인트 목록에 액세스합니다.
3.  모델 체크포인트 이름에 대한 `fine_tuned_model_checkpoint` 필드를 찾습니다.
4.  최종 파인튜닝된 모델처럼 이 모델을 사용합니다.

체크포인트 객체에는 이 모델의 유용성을 판단하는 데 도움이 되는 `metrics` 데이터가 포함되어 있습니다. 예를 들어, 응답은 다음과 같습니다:

```json
{
  "object": "fine_tuning.job.checkpoint",
  "id": "ftckpt_zc4Q7MP6XxulcVzj4MZdwsAB",
  "created_at": 1519129973,
  "fine_tuned_model_checkpoint": "ft:gpt-3.5-turbo-0125:my-org:custom-suffix:96olL566:ckpt-step-2000",
  "metrics": {
    "full_valid_loss": 0.134,
    "full_valid_mean_token_accuracy": 0.874
  },
  "fine_tuning_job_id": "ftjob-abc123",
  "step_number": 2000
}
```

각 체크포인트는 다음을 지정합니다:

*   `step_number`: 체크포인트가 생성된 스텝 (각 에포크는 훈련 세트의 스텝 수를 배치 크기로 나눈 값)
*   `metrics`: 체크포인트가 생성된 스텝에서의 파인튜닝 작업에 대한 메트릭을 포함하는 객체

현재는 작업의 마지막 세 에포크에 대한 체크포인트만 저장되고 사용할 수 있습니다.