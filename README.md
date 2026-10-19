# 코드기어스 LOST COLORS PSP 한글패치 · FontFix2 시험판

기존 한글패치의 대사 글자 깨짐과 PSP 로더 문제를 보수한 **FontFix2 시험판**입니다. **일본판 1.01 원본 ISO에 한 번 적용**하면 기존 번역과 이번 수정이 함께 반영됩니다.

2026-10-19 사용자가 **PSP-3000 / 6.61 ARK-5**에서 “fix2 어느정도 되는듯.”이라고 보고했습니다. 제한적으로 개선을 확인한 결과이며 전체 대사·전 루트·이름 입력·저장/불러오기 검증은 남아 있습니다.

## 다운로드와 적용

1. [릴리스의 `Code_Geass_KO_PSP_FontFix2_patch.zip`](https://github.com/ssjwoo/code-geass-lost-colors-korean-patch/releases/tag/fontfix2-preview)를 받아 새 폴더에 전부 풉니다.
2. 일본판 **v1.01 원본 ISO**를 `Apply-Fix.cmd` 위에 끌어 놓습니다. 더블클릭 후 파일 선택도 가능합니다.
3. 원본·패치·적용 도구와 결과의 SHA256 검사 후 `output/Code_Geass_KO_PSP_FontFix2.iso`가 생성됩니다.
4. 기존 세이브를 백업한 뒤 결과 ISO를 PSP 메모리카드의 `ISO` 폴더로 복사해 실행합니다.

Windows x64와 기본 Windows PowerShell을 사용합니다. Python 설치는 필요 없습니다. 원본과 기존 결과는 덮어쓰지 않습니다. v2.00 원본, 기존 한글 ISO, NativePoC1 또는 FontFix2 자체에는 이 패치를 적용할 수 없습니다. 이미 FontFix2 ISO를 쓰고 있다면 다시 만들 필요가 없습니다.

**GitHub의 자동 생성 `Source code (zip)` 대신 이름에 `FontFix2_patch.zip`가 들어간 릴리스 첨부 파일**을 받으세요. 저장소를 clone했다면 릴리스의 `Code_Geass_JP_v101_to_KO_PSP_FontFix2.xdelta`를 적용 스크립트와 같은 폴더에 둡니다.

## 수정 내용

- 646개 대사 자원에 포함된 한글·ASCII·문장부호 글자 그림을 Noto Sans KR 기반으로 재생성했습니다.
- 기존 29,461개 문자열 레코드의 문구·제어코드·글자 번호를 보존했습니다. FontFix2의 글자 수정 과정에서 메트릭·팔레트·코드·배치를 바꾸지 않았습니다.
- 기존 이름 인코딩에 쓰이는 가나·한자 슬롯의 그림을 보존했습니다.
- 기존 중간 빌드의 PSP 로더 및 SOP0/UNION 참조 보수도 통합되어 있습니다.

[업데이트 내역](docs/CHANGELOG.md) · [검증 범위와 남은 문제](docs/TESTING.md) · [기술 설명](docs/TECHNICAL_NOTES.md) · [크레딧과 라이선스](docs/CREDITS.md)

## 지원 원본과 결과

| 구분 | 크기(바이트) | SHA256 |
|---|---:|---|
| 일본판 1.01 원본, ULJS00135 | 913,670,144 | `2fff44d387c88c7243eba66c433afa2fa29d24e9b3a4347c48de4a8a41ae27ce` |
| FontFix2 결과 ISO | 1,014,665,216 | `56496c492fb2298b2b5350fb7758fe5c04ae13852076b9aa4bac6de85c819c8c` |

원본 CRC32: `5DE82E84`. 결과 CRC32: `9C8D8669`. 파일 이름보다 크기와 SHA256으로 원본을 식별합니다. 세부 해시는 [manifest.json](manifest.json)에 있습니다.

## 배포 범위

릴리스에는 차분 패치, 적용 도구, 문서와 라이선스를 담았습니다. 게임 ISO·추출 자원·세이브는 제공하지 않습니다. **완성 한글판이 아니며** 일본어 메뉴·이미지·영상 글자 및 전체 번역 누락 조사가 남아 있습니다. 저장 형식은 이번 수정 대상이 아니지만 실기 저장/불러오기 호환성은 별도 확인되지 않았습니다.
