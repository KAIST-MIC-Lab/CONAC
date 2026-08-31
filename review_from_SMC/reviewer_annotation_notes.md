# Reviewer 코멘트별 내부 메모

## Reviewer 1

### Comment 1

- 기존 방법과 비교해 무엇이 개선되었는지 기여를 명확하게 주장할 필요가 있음.
- 기존에 발표한 본인 논문들과의 차별점을 추가로 설명할 필요가 있음.

### Comment 2

- Lagrange multiplier의 수렴성 또는 boundedness에 대한 분석이 필요함.

### Comment 3

- LICQ 조건을 엄밀하게 증명할 필요가 있음.

### Comment 4

- Reviewer는 비교군이 모두 저자가 설계한 방법이라고 지적함.
- 실제로는 이전 논문에서도 다른 연구의 방법들과 비교하였음.
- 다만 외부 방법 전체를 그대로 비교한 것이 아니라, 해당 방법의 부가적인 장치 또는 핵심 아이디어를 본 연구의 제어기에 적용하여 비교한 것임.
- 비교 방법의 선정 근거와 관련 내용은 원고에 첨부되어 있음.
- MPC 등 다른 최적화 기반 방법은 unknown system이라는 문제 설정과 MCU 기반 구현 조건 때문에 직접 비교하기 어려움.

### Comment 5

- Notation과 문법 오류를 전반적으로 검토할 필요가 있음.

## Reviewer 2

### Comment 1

- Introduction의 분석이 너무 얕음.
- 기존 연구의 어려움과 research gap을 설명하고, 제안 방법이 그 간극을 어떻게 줄이는지 중심으로 보완할 필요가 있음.

### Comment 2

- 제안 방법의 장점과 단점을 함께 조사하고 논의할 필요가 있음.

### Comment 3

- DNN weight 문제가 발생하는 조건 또는 이상적인 상황에 대한 분석이 필요함.

### Comment 4

- Singularity 문제에 대한 분석을 요구하는 것인지 확인이 필요함.

### Comment 5

- Error boundedness에 대해 더욱 엄밀한 분석이 필요함.

### Comment 6

- 제어입력이 입력 제약조건의 경계에 도달했을 때 나타나는 특성을 설명할 필요가 있음.
- 해당 거동을 Lyapunov 함수로 해석할 수 있는지 검토할 필요가 있음.

### Comment 7

- Controller parameter와 DNN architecture를 어떤 방식으로 tuning했는지 설명할 필요가 있음.

### Comment 8

- 초기값이 좋지 않을 때 제안 제어기의 반응을 분석할 필요가 있음.

### Comment 9

- Suspension system에 적용해 보라는 의미인지 확인이 필요함.

### Comment 10

- Transient 구간에 대한 분석이 부족함.
- 초기오차 없이 제어하는 것이 기본 설정이므로, 이에 대한 추가 설명이 필요함.

## Reviewer 3

### Comment 1

- Convex saturation에 대한 정의를 명확하게 제시할 필요가 있음.

### Comment 2

- 독자의 이해를 위해 weight adaptation law의 최적화 설계 과정을 더욱 명확하게 설명할 필요가 있음.

### Comment 3

- 논문의 구성과 논리적 흐름을 개선할 필요가 있음.
- 특히 assumptions와 lemmas의 위치 및 역할을 체계적으로 정리할 필요가 있음.

### Comment 4

- 논문에서 주장하는 기여가 지나치게 많아 보이는지 검토하고, 핵심 기여 중심으로 정리할 필요가 있음.

### Comment 5

- 기호 정의와 표기의 일관성을 전반적으로 검토할 필요가 있음.

### Comment 6

- 주요 기여가 validation에서 충분히 드러나지 않음.
- 특히 Fig. 6의 목적이 불분명함. 특정 시간 구간을 확대하여 분석하기 위한 그림이라는 점을 명확하게 설명할 필요가 있음.
- Reviewer 1과 Reviewer 2의 유사 코멘트에 대한 대응과 연계하여, 기존 연구, BLF, projection algorithm 등과의 차별성과 장점을 구체적으로 설명할 필요가 있음.
- Fig. 6의 목적은 기존 설명으로도 어느 정도 전달되지만, 더 명확하게 제시할 방법을 검토할 필요가 있음.

## Reviewer 4

### Comment 1

- 두 번째 논문에서 adaptation-law approximation에 사용한 matrix sign의 근거가 불명확하다는 지적임.

### Comment 2

- DNN architecture 선정에 대한 정량적 분석이 부족함.
- 해당 architecture는 실험적으로 선정한 것임.
- Reviewer 2 Comment 7의 tuning 관련 코멘트와 유사함.

### Comment 3

- 산업적 시나리오에 대한 고려가 부족함.
- Disturbance와 parameter uncertainty에 대한 검증이 없음.
- 추가적인 실험 시나리오를 고려할 필요가 있음.
- Disturbance 실험은 추가할 수 있음.
- Parameter uncertainty는 이미 system dynamics를 모른다고 가정한 문제 설정에 포함되므로, 별도 검증이 필요한지는 검토가 필요함.

### Comment 4

- 두 번째 논문의 실험 시나리오가 단순하다는 지적임. 다만 해당 논문은 현재 심사 대상이 아니라 이전 IECON 논문임.
- 두 번째 논문은 현재 원고와 다른 실험 환경을 사용하므로, 현재 원고에 가혹한 운전 조건을 추가하는 것으로 충분한지 검토할 필요가 있음.

### Comment 5

- 두 번째 논문의 reference-current waveform이 단순하다는 지적임. 다만 해당 논문은 현재 심사 대상이 아니라 이전 IECON 논문임.
- 대응 방향은 Reviewer 4 Comment 4와 동일함.

### Comment 6

- IFT 사용에 대한 엄밀한 분석이 필요함.
- Saturation boundary에서 partial-derivative term이 singular해질 수 있다는 지적임.
- 직접적으로는 현재 심사 대상이 아닌 이전 IECON 논문에 관한 코멘트임.
- 다만 현재 원고에서도 IFT를 사용하고 관련 지적을 해결하는 방식으로 대응할 수 있는지 검토할 필요가 있음.

### Comment 7

- Reviewer가 제시한 최신 연구들과 본 논문의 차별성을 명확하게 비교할 필요가 있음.
- 비교 대상으로 제시된 논문은 다음과 같음.
  - *Adaptive critic design for safety-optimal FTC of unknown nonlinear systems with asymmetric constrained-input*
  - *Reinforcement learning-based secure tracking control for nonlinear interconnected systems: An event-triggered solution approach*
  - *A lightweight network enhanced by attention-guided cross-scale interaction for underwater object detection*
  - *Observer based fault tolerant control design for saturated nonlinear systems with full state constraints via a novel event-triggered mechanism*
