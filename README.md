# FIR_Filter_System


## 개요
  - 숭실대학교 2023년 2학기 디지털시스템설계에서 진행한 이미지 필터 처리 프로젝트입니다.<br>
  - 개인 프로젝트를 통해 320x320 크기의 이미지를 Sobel 필터를 통해 edge detection합니다.<br>
  - 이후 팀을 구성하여 FHD 이미지를 Sobel 필터를 통한 edge detection합니다.<br>
  - Demux → TC FIFO → MAC → Saturation&Output reg로 이어지는 구조입니다.<br>
  - 필터의 속도를 높일 수 있는 구조를 제작합니다.<br>
  - 자세한 내용은 아래 링크를 통해 확인 할 수 있습니다.
    <br>
    [발표자료](https://github.com/yjm020500/FIR_Filter_System/blob/main/Docs/Digital%20System%20Design.pdf)
    <br>
    [프로젝트 보고서](https://github.com/yjm020500/FIR_Filter_System/blob/main/Docs/FIR%20filter%20PE%20%EB%A5%BC%20%EC%9D%B4%EC%9A%A9%ED%95%9C%20%EB%8B%A4%EC%A4%91%EC%B2%98%EB%A6%AC%20FIR%20filter%20%EC%8B%9C%EC%8A%A4%ED%85%9C%20%EA%B5%AC%EC%84%B1.pdf)
  
<br>

## 상세 내용
### 프로젝트 목표
  - 1920x1080의 FHD 이미지를 Sobel 마스크를 통한 edge detection합니다.
<br>

### 기본 필터
  - 320x320 필터
      - RGB 888 구성의 pixel 값이 사용됩니다.
        <br>
      <img width="1397" height="242" alt="image" src="https://github.com/user-attachments/assets/0b60a16a-5eec-4612-a520-b138f8dd6867" />
      <br>
     <br>
  - 필터 구조
    - 전체 필터 구조
      - 실제 필터링하는 Calc_block을 Core FSM이 제어합니다.
       <br>
          <img width="876" height="476" alt="image" src="https://github.com/user-attachments/assets/12323e68-cc58-4bb7-9f38-55097617c0c9" />
       <br>
       <br>
    - Calculation Block
      - 필터링이 이루어지는 Calculation Block의 구조는 Demux → TC FIFO → MAC → Saturation&Output reg입니다.
         <br>
        <img width="619" height="562" alt="image" src="https://github.com/user-attachments/assets/ef54ce78-7d88-4dd6-88c0-3bb13f04199d" />
        <br>
        <br>
    - Core FSM
      - Core FSM은 다음과 같은 구조입니다.
        <br>
         <img width="817" height="498" alt="image" src="https://github.com/user-attachments/assets/c5c92e86-4692-45af-a918-040e5e1c98cc" />
        <br>
        <br>
      
       
- 필터 tap
  - 이때 TC_FIFO는 다음과 같은 필터의 tap 계수를 저장하고 순서에 맞게 출력합니다.
    <br>  
        <img width="132" height="120" alt="image" src="https://github.com/user-attachments/assets/8bb1bac5-6777-4723-ba70-40518d21ca31" />
     <br>
        - [fiter tap](https://github.com/yjm020500/FIR_Filter_System/blob/main/Code/Module/filter_tap.dat)
        <br>
        <br>
- 필터링 결과
      <br>
      <img width="436" height="220" alt="image" src="https://github.com/user-attachments/assets/882a4108-1b4f-4101-95aa-63fbba82c8c0" />
        <br>
  - 왼쪽의 이미지가 오른쪽과 같이 edge detection되었음을 확인하였습니다.
    <br>
    <br>

### FHD 필터
  - Testbench 제작
    1. 1920x1080의 RGB pixel값을 1차원 배열로 저장합니다.
    2. 이미지 형태로 다루기 위해 2차원 배열로 reshape합니다.
    3. 필터에 들어갈 9개의 값을 가져와 필터링 후 저장합니다.
    4. 이때 외곽의 pixel들은 zero padding한 효과를 주기 위해 이미지 밖의 값을<br>
       가져와야 할 때는 pixel값 대신 0을 넣는 구조로 구성합니다.<br>
       <img width="389" height="257" alt="image" src="https://github.com/user-attachments/assets/55565291-ed4c-4149-8247-ac32e4dfc2c2" />
    <br>
    <br>
  - 사용한 이미지 및 결과
    - 사용한 이미지<br>
        <img width="660" height="373" alt="image" src="https://github.com/user-attachments/assets/3a52e5a9-dfb1-4b35-9355-0a8e0127087a" />
        <br>
    - 필터링 결과<br>
        <img width="632" height="326" alt="image" src="https://github.com/user-attachments/assets/f142925a-b6a6-425d-9308-97ecc5be7dce" />
  <br>
  <br>

### 필터 변형
  - 하나의 필터 안에서 병렬 처리<br>
    <img width="625" height="370" alt="image" src="https://github.com/user-attachments/assets/0f63d733-d3e2-4fd5-9035-d87d569f290e" />
    <br>
    - 한 필터 안에 MAC 연산과 Sautration&Output reg를 병렬로 배치하여 계산합니다.
    - code
      10개 병렬 MAC and Saturation&Output reg
    - Testbench
      10개 병렬 MAC and Saturation&Output reg TB
      <br>
  - 여러 필터의 병렬 사용<br>
    <img width="691" height="348" alt="image" src="https://github.com/user-attachments/assets/7345bfbd-df9b-4c98-95f7-ab03a904bb0f" />
    <br>
    - 기본 필터 여러 개를 병렬로 처리합니다.
    - code <br>
      4개 병렬 필터 <br>
      16개 병렬 필터 <br>
      64개 병렬 필터 <br>
    - Testbench <br>
      4개 병렬 필터 TB <br>
      16개 병렬 필터 TB <br>
      64개 병렬 필터 TB <br>
<br>

### 최종 결과 <br>
  <img width="997" height="324" alt="image" src="https://github.com/user-attachments/assets/64f5be2d-d171-4e0a-be7f-46f12fe424c7" />
  <br>
  - 성능 개선 결과: simulation상에서 걸린 시간을 비교합니다. <br>
  - 출력 개선 결과: 실제 필터링을 시작해서 이미지가 나올 때까지 걸린 시간을 비교합니다.

