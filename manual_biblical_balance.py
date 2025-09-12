#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import random
from collections import defaultdict

def create_biblically_balanced_questions():
    """성경적 특성에 맞는 20개 질문 생성"""
    
    questions = [
        {
            "id": 1,
            "text": "하나님께서 큰 사명을 주셨을 때 당신은?",
            "options": [
                {
                    "text": "즉시 순종하며 행동에 옮긴다",
                    "scores": {
                        "david": 4,
                        "peter": 4,
                        "rebekah": 3,
                        "paul": 2,
                        "jeremiah": 1  # 예레미야도 결국 순종했지만 주저했음
                    }
                },
                {
                    "text": "깊이 기도하며 하나님의 뜻을 더 구한다",
                    "scores": {
                        "mary": 4,
                        "jeremiah": 4,
                        "barnabas": 3,
                        "esther": 3  # 에스더는 금식 기도했음
                    }
                },
                {
                    "text": "계획을 세우고 체계적으로 준비한다",
                    "scores": {
                        "noah": 4,
                        "moses": 4,  # 모세는 체계적 계획가
                        "luke": 4,   # 누가는 세밀한 계획자
                        "solomon": 3,
                        "peter": 1   # 베드로도 계획을 세우지만 즉흥적 성향
                    }
                },
                {
                    "text": "지혜로운 조언자들과 상의한다",
                    "scores": {
                        "solomon": 4,
                        "esther": 5,  # 모르드개와 상의
                        "luke": 3,
                        "barnabas": 2,
                        "david": 1   # 다윗도 상의하지만 종종 독단적
                    }
                }
            ]
        },
        {
            "id": 2,
            "text": "어려운 상황에 직면했을 때 당신의 첫 반응은?",
            "options": [
                {
                    "text": "다른 사람들과 함께 해결책을 찾는다",
                    "scores": {
                        "deborah": 4,
                        "barnabas": 4,
                        "paul": 3,
                        "esther": 4  # 백성들과 함께 금식
                    }
                },
                {
                    "text": "홀로 조용한 곳에서 기도하며 답을 구한다",
                    "scores": {
                        "jeremiah": 4,
                        "mary": 4,
                        "barnabas": 2,
                        "david": 2
                    }
                },
                {
                    "text": "주변 사람들을 격려하고 이끌어 나간다",
                    "scores": {
                        "paul": 4,
                        "deborah": 4,
                        "moses": 4,  # 백성들을 격려하고 인도
                        "peter": 3
                    }
                },
                {
                    "text": "신중히 생각하고 분석한 후 행동한다",
                    "scores": {
                        "solomon": 4,
                        "luke": 4,   # 정확한 조사 후 기록
                        "joseph": 5, # 꿈 해석과 계획
                        "noah": 3
                    }
                }
            ]
        },
        {
            "id": 3,
            "text": "새로운 공동체에 들어갔을 때 당신은?",
            "options": [
                {
                    "text": "적극적으로 사람들에게 다가가 인사한다",
                    "scores": {
                        "peter": 4,
                        "paul": 4,
                        "david": 3,
                        "rebekah": 2
                    }
                },
                {
                    "text": "먼저 관찰하며 분위기를 파악한다",
                    "scores": {
                        "luke": 4,    # 세밀한 관찰자
                        "joseph": 4,  # 상황 파악 후 행동
                        "solomon": 3,
                        "esther": 4   # 궁중 상황 파악
                    }
                },
                {
                    "text": "봉사할 곳을 찾아 섬김에 참여한다",
                    "scores": {
                        "barnabas": 4,
                        "mary": 4,
                        "esther": 3,
                        "luke": 3    # 의사로서 섬김
                    }
                },
                {
                    "text": "조용히 예배에 집중하며 은혜받기를 원한다",
                    "scores": {
                        "jeremiah": 4,
                        "mary": 3,
                        "noah": 3,
                        "daniel": 2
                    }
                }
            ]
        },
        {
            "id": 4,
            "text": "팀 사역을 할 때 당신의 역할은?",
            "options": [
                {
                    "text": "팀원들과 소통하며 분위기를 이끈다",
                    "scores": {
                        "peter": 4,
                        "paul": 4,
                        "david": 3,
                        "barnabas": 2
                    }
                },
                {
                    "text": "묵묵히 자신의 역할에 충실한다",
                    "scores": {
                        "luke": 4,    # 충실한 동역자
                        "mary": 4,
                        "joseph": 4,  # 맡겨진 일에 충실
                        "noah": 3
                    }
                },
                {
                    "text": "전체적인 방향을 제시하고 조직한다",
                    "scores": {
                        "moses": 4,   # 리더십과 조직력
                        "deborah": 4,
                        "solomon": 3,
                        "paul": 3
                    }
                },
                {
                    "text": "깊이 있는 아이디어와 통찰을 제공한다",
                    "scores": {
                        "solomon": 4,
                        "joseph": 5,  # 지혜로운 통찰
                        "jeremiah": 4,
                        "luke": 3
                    }
                }
            ]
        },
        {
            "id": 5,
            "text": "에너지를 충전하는 방법은?",
            "options": [
                {
                    "text": "사람들과 함께 교제하며 대화한다",
                    "scores": {
                        "peter": 4,
                        "paul": 4,
                        "david": 3,
                        "barnabas": 3
                    }
                },
                {
                    "text": "혼자만의 시간을 가지며 조용히 묵상한다",
                    "scores": {
                        "jeremiah": 4,
                        "mary": 4,
                        "luke": 3,   # 조용한 연구
                        "daniel": 3,
                        "peter": 1   # 베드로도 묵상하지만 주로 사교적
                    }
                },
                {
                    "text": "새로운 프로젝트나 도전에 몰입한다",
                    "scores": {
                        "deborah": 4,
                        "joseph": 5,  # 새로운 도전과 해결책
                        "solomon": 3,
                        "rebekah": 3
                    }
                },
                {
                    "text": "규칙적인 일상과 안정적인 환경에서",
                    "scores": {
                        "noah": 4,
                        "moses": 4,   # 규칙적인 율법과 제도
                        "luke": 4,    # 체계적인 연구
                        "solomon": 2
                    }
                }
            ]
        },
        {
            "id": 6,
            "text": "하나님의 말씀을 다룰 때 당신은?",
            "options": [
                {
                    "text": "다른 사람들과 함께 나누며 토론한다",
                    "scores": {
                        "paul": 4,
                        "barnabas": 4,
                        "peter": 3,
                        "deborah": 2,
                        "jeremiah": 1  # 예레미야도 나누지만 주로 혼자 선포
                    }
                },
                {
                    "text": "개인적으로 묵상하며 깊이 있게 생각한다",
                    "scores": {
                        "mary": 4,
                        "jeremiah": 4,
                        "daniel": 3,
                        "solomon": 3
                    }
                },
                {
                    "text": "실생활에 어떻게 적용할지 구체적으로 계획한다",
                    "scores": {
                        "noah": 3,
                        "moses": 5,   # 율법의 실제적 적용
                        "luke": 4,    # 실용적 접근
                        "esther": 4   # 실제 상황에 적용
                    }
                },
                {
                    "text": "지혜와 통찰을 구하며 분석적으로 연구한다",
                    "scores": {
                        "solomon": 4,
                        "luke": 4,    # 정확한 연구와 기록
                        "joseph": 4,  # 꿈과 말씀의 해석
                        "daniel": 3
                    }
                }
            ]
        },
        {
            "id": 7,
            "text": "미래에 대한 하나님의 인도하심을 구할 때?",
            "options": [
                {
                    "text": "신뢰하는 조언자들과 상담하며 지혜를 구한다",
                    "scores": {
                        "esther": 5,  # 모르드개와 상담
                        "solomon": 3,
                        "barnabas": 3,
                        "luke": 2
                    }
                },
                {
                    "text": "기도와 말씀을 통해 직접 하나님께 구한다",
                    "scores": {
                        "daniel": 4,
                        "jeremiah": 4,
                        "mary": 3,
                        "david": 3
                    }
                },
                {
                    "text": "여러 가능성을 분석하고 체계적으로 준비한다",
                    "scores": {
                        "solomon": 4,
                        "luke": 4,    # 체계적 조사
                        "joseph": 5,  # 7년 기근 대비
                        "noah": 3
                    }
                },
                {
                    "text": "하나님을 신뢰하며 한 걸음씩 순종한다",
                    "scores": {
                        "noah": 4,
                        "moses": 4,   # 40년 광야 인도
                        "mary": 3,
                        "david": 3
                    }
                }
            ]
        },
        {
            "id": 8,
            "text": "문제 해결 방법을 찾을 때?",
            "options": [
                {
                    "text": "주변 사람들과 브레인스토밍한다",
                    "scores": {
                        "paul": 4,
                        "deborah": 3,
                        "barnabas": 3,
                        "peter": 3
                    }
                },
                {
                    "text": "혼자 깊이 생각하며 최선의 방법을 찾는다",
                    "scores": {
                        "solomon": 4,
                        "joseph": 5,  # 꿈 해석과 해결책
                        "jeremiah": 3,
                        "luke": 4     # 연구를 통한 해결
                    }
                },
                {
                    "text": "과거 경험과 사례를 참고한다",
                    "scores": {
                        "luke": 4,    # 역사 기록 참고
                        "moses": 4,   # 과거 하나님의 역사
                        "noah": 3,
                        "solomon": 2
                    }
                },
                {
                    "text": "즉석에서 창의적으로 대응한다",
                    "scores": {
                        "david": 4,
                        "peter": 3,
                        "joseph": 3,  # 위기 상황에서 기지
                        "rebekah": 3
                    }
                }
            ]
        },
        {
            "id": 9,
            "text": "하나님의 부르심을 분별할 때?",
            "options": [
                {
                    "text": "공동체의 확신과 동의를 구한다",
                    "scores": {
                        "paul": 3,
                        "esther": 4,  # 백성들과 함께 금식
                        "barnabas": 2,
                        "deborah": 2
                    }
                },
                {
                    "text": "개인적인 기도와 말씀 확신을 통해",
                    "scores": {
                        "jeremiah": 4,
                        "daniel": 4,
                        "mary": 3,
                        "david": 3
                    }
                },
                {
                    "text": "성경적 원리와 지혜를 통해 판단한다",
                    "scores": {
                        "solomon": 4,
                        "moses": 5,   # 율법의 원리
                        "luke": 4,    # 정확한 원리 적용
                        "joseph": 3
                    }
                },
                {
                    "text": "하나님의 때를 기다리며 인내한다",
                    "scores": {
                        "noah": 4,
                        "moses": 3,
                        "mary": 3,
                        "esther": 4   # 적절한 타이밍 기다림
                    }
                }
            ]
        },
        {
            "id": 10,
            "text": "복음을 전할 때 당신의 방법은?",
            "options": [
                {
                    "text": "적극적으로 사람들에게 다가가 직접 전한다",
                    "scores": {
                        "peter": 4,
                        "paul": 4,
                        "david": 3,
                        "barnabas": 2,
                        "jeremiah": 1  # 예레미야도 전했지만 처음엔 꺼려했음
                    }
                },
                {
                    "text": "개인적 관계를 통해 자연스럽게 전한다",
                    "scores": {
                        "barnabas": 4,
                        "luke": 3,    # 개인적 관찰과 기록
                        "mary": 3,
                        "esther": 3
                    }
                },
                {
                    "text": "체계적인 가르침과 설명으로",
                    "scores": {
                        "paul": 3,
                        "luke": 4,    # 체계적 기록과 설명
                        "moses": 4,   # 체계적 율법 교육
                        "solomon": 3
                    }
                },
                {
                    "text": "삶의 모범을 통해 조용히 증거한다",
                    "scores": {
                        "mary": 4,
                        "joseph": 5,  # 이집트에서 삶으로 증거
                        "daniel": 4,
                        "noah": 3
                    }
                }
            ]
        },
        {
            "id": 11,
            "text": "공동체에서 갈등이 생겼을 때?",
            "options": [
                {
                    "text": "적극적으로 중재에 나서 해결을 도모한다",
                    "scores": {
                        "moses": 4,   # 백성들 간 갈등 해결
                        "paul": 4,
                        "deborah": 4,
                        "barnabas": 3
                    }
                },
                {
                    "text": "조용히 기도하며 하나님의 인도하심을 구한다",
                    "scores": {
                        "jeremiah": 4,
                        "mary": 3,
                        "daniel": 3,
                        "david": 3
                    }
                },
                {
                    "text": "객관적으로 분석하여 공정한 해결책을 제시한다",
                    "scores": {
                        "solomon": 4,
                        "luke": 3,
                        "joseph": 5,  # 공정하고 지혜로운 판단
                        "deborah": 3
                    }
                },
                {
                    "text": "화해와 용서의 분위기를 조성한다",
                    "scores": {
                        "barnabas": 4,
                        "joseph": 4,  # 형들을 용서
                        "david": 3,
                        "esther": 3
                    }
                }
            ]
        },
        {
            "id": 12,
            "text": "중요한 결정을 내려야 할 때?",
            "options": [
                {
                    "text": "신뢰하는 사람들과 충분히 상의한다",
                    "scores": {
                        "esther": 5,  # 모르드개와 상의
                        "paul": 3,
                        "barnabas": 3,
                        "solomon": 2
                    }
                },
                {
                    "text": "하나님께 기도하며 확신을 구한다",
                    "scores": {
                        "daniel": 4,
                        "jeremiah": 4,
                        "mary": 3,
                        "david": 3
                    }
                },
                {
                    "text": "모든 정보를 수집하고 분석한 후 결정한다",
                    "scores": {
                        "solomon": 4,
                        "luke": 4,    # 정확한 조사
                        "joseph": 5,  # 상황 분석 후 결정
                        "moses": 3
                    }
                },
                {
                    "text": "직감과 영감을 따라 과감하게 결정한다",
                    "scores": {
                        "david": 4,
                        "peter": 3,
                        "rebekah": 3,
                        "deborah": 3
                    }
                }
            ]
        },
        {
            "id": 13,
            "text": "다른 사람을 도울 때?",
            "options": [
                {
                    "text": "함께 행동하며 직접적으로 문제를 해결한다",
                    "scores": {
                        "peter": 4,
                        "moses": 3,   # 직접 백성들 문제 해결
                        "deborah": 3,
                        "paul": 3
                    }
                },
                {
                    "text": "조용히 뒤에서 필요한 것을 지원한다",
                    "scores": {
                        "barnabas": 4,
                        "luke": 4,    # 바울을 도운 동역자
                        "mary": 4,
                        "esther": 3
                    }
                },
                {
                    "text": "체계적으로 계획을 세워 장기적으로 돕는다",
                    "scores": {
                        "luke": 4,    # 체계적 지원
                        "joseph": 5,  # 7년 기근 대비책
                        "solomon": 3,
                        "moses": 4    # 체계적 제도 마련
                    }
                },
                {
                    "text": "상황에 맞춰 유연하게 도움을 준다",
                    "scores": {
                        "joseph": 4,  # 상황에 맞는 지혜
                        "rebekah": 3,
                        "david": 3,
                        "esther": 4   # 상황에 맞는 전략
                    }
                }
            ]
        },
        {
            "id": 14,
            "text": "말씀을 가르칠 때?",
            "options": [
                {
                    "text": "참여자들과 활발히 토론하며 진행한다",
                    "scores": {
                        "paul": 4,
                        "peter": 3,
                        "barnabas": 3,
                        "deborah": 3
                    }
                },
                {
                    "text": "차분하고 깊이 있게 말씀을 전한다",
                    "scores": {
                        "jeremiah": 4,
                        "luke": 3,
                        "solomon": 3,
                        "daniel": 3
                    }
                },
                {
                    "text": "체계적으로 구조화하여 가르친다",
                    "scores": {
                        "luke": 4,    # 체계적 기록과 설명
                        "moses": 5,   # 율법의 체계적 교육
                        "paul": 3,
                        "solomon": 3
                    }
                },
                {
                    "text": "실생활 적용에 초점을 맞춰 진행한다",
                    "scores": {
                        "moses": 4,   # 율법의 실제 적용
                        "joseph": 4,  # 실용적 지혜
                        "noah": 3,
                        "esther": 3
                    }
                }
            ]
        },
        {
            "id": 15,
            "text": "일상생활을 관리할 때?",
            "options": [
                {
                    "text": "계획을 세우고 체계적으로 실행한다",
                    "scores": {
                        "luke": 4,    # 체계적 연구
                        "moses": 4,   # 체계적 제도와 규칙
                        "joseph": 4,  # 계획적 관리
                        "noah": 4
                    }
                },
                {
                    "text": "상황에 따라 유연하게 대응한다",
                    "scores": {
                        "joseph": 4,  # 상황에 맞는 대응
                        "rebekah": 4,
                        "david": 3,
                        "peter": 3
                    }
                },
                {
                    "text": "다른 사람들과 협력하며 함께 진행한다",
                    "scores": {
                        "paul": 4,
                        "barnabas": 3,
                        "moses": 3,   # 조력자들과 협력
                        "deborah": 3
                    }
                },
                {
                    "text": "기도하며 하나님께 맡기고 순종한다",
                    "scores": {
                        "mary": 4,
                        "daniel": 4,
                        "jeremiah": 3,
                        "noah": 3
                    }
                }
            ]
        },
        {
            "id": 16,
            "text": "예상치 못한 상황이 생겼을 때?",
            "options": [
                {
                    "text": "즉시 행동하며 적극적으로 대처한다",
                    "scores": {
                        "peter": 4,
                        "david": 3,
                        "rebekah": 3,
                        "deborah": 3,
                        "luke": 1    # 누가도 행동하지만 주로 신중함
                    }
                },
                {
                    "text": "일단 멈추고 기도하며 하나님께 구한다",
                    "scores": {
                        "daniel": 4,
                        "jeremiah": 3,
                        "mary": 3,
                        "david": 3
                    }
                },
                {
                    "text": "상황을 분석하고 최선의 방법을 찾는다",
                    "scores": {
                        "solomon": 4,
                        "luke": 4,    # 정확한 상황 파악
                        "joseph": 5,  # 위기 상황 분석
                        "moses": 3
                    }
                },
                {
                    "text": "경험과 지혜를 바탕으로 신중히 대응한다",
                    "scores": {
                        "moses": 4,   # 경험을 통한 지혜
                        "joseph": 4,  # 과거 경험 활용
                        "noah": 3,
                        "esther": 4   # 신중한 대응
                    }
                }
            ]
        },
        {
            "id": 17,
            "text": "새로운 사역을 시작할 때?",
            "options": [
                {
                    "text": "사람들을 모으고 팀을 구성한다",
                    "scores": {
                        "moses": 4,   # 조력자들 세움
                        "paul": 4,
                        "deborah": 4,
                        "barnabas": 3
                    }
                },
                {
                    "text": "충분히 기도하고 준비한 후 시작한다",
                    "scores": {
                        "jeremiah": 4,
                        "daniel": 3,
                        "mary": 3,
                        "moses": 3
                    }
                },
                {
                    "text": "체계적인 계획과 준비를 통해 시작한다",
                    "scores": {
                        "luke": 4,    # 체계적 준비
                        "joseph": 5,  # 철저한 계획
                        "solomon": 4,
                        "moses": 4
                    }
                },
                {
                    "text": "하나님의 때를 기다리며 순종한다",
                    "scores": {
                        "mary": 4,
                        "esther": 4,  # 적절한 때 기다림
                        "noah": 3,
                        "daniel": 3
                    }
                }
            ]
        },
        {
            "id": 18,
            "text": "골리앗과 같은 거대한 도전 앞에서 당신은?",
            "options": [
                {
                    "text": "하나님을 향한 믿음으로 과감히 맞선다",
                    "scores": {
                        "david": 4,
                        "daniel": 4,
                        "peter": 3,
                        "deborah": 3
                    }
                },
                {
                    "text": "기도하며 하나님의 도우심을 간구한다",
                    "scores": {
                        "jeremiah": 4,
                        "mary": 3,
                        "esther": 4,  # 금식 기도
                        "daniel": 3
                    }
                },
                {
                    "text": "체계적으로 준비하고 전략을 세운다",
                    "scores": {
                        "solomon": 4,
                        "moses": 4,   # 전략적 계획
                        "joseph": 5,  # 7년 기근 대비 전략
                        "luke": 3
                    }
                },
                {
                    "text": "다른 사람들과 함께 연합하여 대응한다",
                    "scores": {
                        "deborah": 4,
                        "moses": 4,   # 백성들과 연합
                        "esther": 5,  # 백성들과 함께 대응
                        "paul": 3
                    }
                }
            ]
        },
        {
            "id": 19,
            "text": "홍해 앞에서 이집트 군대가 뒤쫓아올 때 당신은?",
            "options": [
                {
                    "text": "하나님께서 길을 열어주실 것을 확신한다",
                    "scores": {
                        "moses": 5,   # 홍해 기적의 주인공
                        "noah": 3,
                        "daniel": 3,
                        "mary": 3
                    }
                },
                {
                    "text": "백성들을 격려하며 하나님을 의지하자고 외친다",
                    "scores": {
                        "moses": 4,   # 백성들 격려
                        "paul": 4,
                        "peter": 3,
                        "deborah": 3
                    }
                },
                {
                    "text": "현실적인 대안을 찾아 신속히 행동한다",
                    "scores": {
                        "joseph": 4,  # 현실적 해결책
                        "rebekah": 4,
                        "solomon": 3,
                        "luke": 2
                    }
                },
                {
                    "text": "조용히 기도하며 하나님의 인도하심을 기다린다",
                    "scores": {
                        "jeremiah": 4,
                        "mary": 4,
                        "luke": 3,
                        "esther": 3
                    }
                }
            ]
        },
        {
            "id": 20,
            "text": "바벨탑을 쌓자는 제안이 나왔을 때 당신은?",
            "options": [
                {
                    "text": "하나님의 뜻이 아님을 분명히 반대한다",
                    "scores": {
                        "jeremiah": 4,
                        "moses": 4,   # 하나님의 뜻 선포
                        "daniel": 4,
                        "noah": 3
                    }
                },
                {
                    "text": "사람들을 설득하여 바른 길로 인도한다",
                    "scores": {
                        "paul": 4,
                        "moses": 4,   # 백성들 인도
                        "deborah": 3,
                        "barnabas": 3
                    }
                },
                {
                    "text": "하나님의 심판을 경고하며 회개를 촉구한다",
                    "scores": {
                        "jeremiah": 5,  # 심판 경고의 선지자
                        "peter": 3,
                        "moses": 3,
                        "paul": 3
                    }
                },
                {
                    "text": "조용히 떠나 하나님의 뜻을 따른다",
                    "scores": {
                        "noah": 4,
                        "luke": 3,
                        "mary": 3,
                        "esther": 2
                    }
                }
            ]
        }
    ]
    
    return questions

def test_balanced_distribution(questions):
    """균형 잡힌 분포 테스트"""
    results = defaultdict(int)
    
    for _ in range(10000):
        scores = defaultdict(int)
        
        for question in questions:
            random_option = random.choice(question['options'])
            for character, score in random_option['scores'].items():
                scores[character] += score
        
        if scores:
            winner = max(scores.items(), key=lambda x: x[1])
            results[winner[0]] += 1
    
    return results

def main():
    print("🔧 성경적 특성에 맞는 20개 질문 생성 및 테스트")
    
    # 질문 생성
    questions = create_biblically_balanced_questions()
    
    # 테스트 실행
    results = test_balanced_distribution(questions)
    
    # 결과 출력
    print(f"\n📊 성경적 균형 조정 후 분포 (10,000번 테스트):")
    print(f"{'캐릭터':^15} | {'매칭수':^6} | {'비율(%)':^8} | {'목표달성':^8}")
    print("-" * 55)
    
    sorted_results = sorted(results.items(), key=lambda x: x[1], reverse=True)
    
    target_chars = ['moses', 'luke', 'joseph', 'esther']  # 가장 부족했던 4명
    success_count = 0
    
    for char_id, count in sorted_results:
        percentage = (count / 10000) * 100
        
        if char_id in target_chars:
            if percentage >= 3.0:  # 3% 이상이면 성공
                target_status = "✅"
                success_count += 1
            else:
                target_status = "❌"
        else:
            if 2 <= percentage <= 10:  # 합리적 범위
                target_status = "✅"
            else:
                target_status = "🔶"
        
        print(f"{char_id:^15} | {count:^6} | {percentage:^8.2f} | {target_status:^8}")
    
    print(f"\n🎯 타겟 캐릭터 성공: {success_count}/4")
    
    # 결과 저장
    if success_count >= 3:  # 4명 중 3명 이상 성공
        with open("/Users/kimjungho/Documents/kimjungho_coding/sns-bible-mbti/assets/data/biblical_questions_final.json", 'w', encoding='utf-8') as f:
            json.dump(questions, f, ensure_ascii=False, indent=2)
        print("✅ 성경적으로 균형 잡힌 20개 질문이 저장되었습니다!")
        return True
    else:
        print("❌ 목표 미달. 추가 조정이 필요합니다.")
        return False

if __name__ == "__main__":
    main()