# wakeflow

task/issue 기반 개인 작업 흐름을 관리하는 Claude Code 플러그인. 진행 중인 작업 단위를 **task**로,
분리된 할 일을 **issue**로 다루며, task 종료 시 압축 노트와 함께 archive에 보존한다.

- 설치명(플러그인 이름): `wakeflow`
- 트리거: `/wakeflow:task:<sub>`, `/wakeflow:issue:<sub>`, `/wakeflow:task`
- 전체 개념·디렉토리 구조·동작 원칙: `reference/wakeflow.md`

## 설치

이 저장소 자체를 마켓플레이스로 등록한 뒤 설치한다.

```
/plugin marketplace add mk0218/claude-plugin-wakeflow
/plugin install wakeflow
```

## 사용 방법

필요시 명시적으로 슬래시 커맨드를 실행한다.
`SessionStart` 훅이 현재 git 브랜치에 연결된 task를 찾아 컨텍스트로 자동 주입한다.

### task — 진행 중인 작업 단위

현재 진행 중인 작업을 task로 다룬다. 시작·업데이트·분할·종료의 수명주기를 갖는다.

| 커맨드 | 설명 |
|---|---|
| `/wakeflow:task:start <설명>` (alias `create`) | 새 task 시작 |
| `/wakeflow:task:update [slug]` | 진행 상황을 task README에 반영 |
| `/wakeflow:task:tidy [slug]` | 큰 task를 subtask로 분할 |
| `/wakeflow:task:end [slug]` | task 종료 (압축 노트 + archive 보존) |
| `/wakeflow:task:list` (`ls`) | 진행 중인 task 목록 |
| `/wakeflow:task:todo` | 현재 task 상태 + 다음 할 일 요약 |
| `/wakeflow:task` | 현재 task 맥락을 세션에 주입 (hook 보강) |

### issue — 분리해 둔 할 일

진행 중인 task와 별도로 나중에 처리할 일을 issue로 등록해 둔다.
처리할 때가 되면 issue로부터 새 task를 시작한다 (issue는 그대로 유지).

| 커맨드 | 설명 |
|---|---|
| `/wakeflow:issue:create [요약]` | 새 issue 등록 |
| `/wakeflow:issue:start <slug>` | issue 처리용 새 task 시작 |
| `/wakeflow:issue:list` (`ls`) | issue 목록 |

## task/issue 데이터의 git 무시 (권장)

task/issue/archive 문서는 프로젝트의 `<project-root>/.claude/local/` 아래에 쌓인다. 이 개인 작업 문서를
팀 레포 히스토리에 올리고 싶지 않다면, `.gitignore` 또는 `.git/local/exclude`(권장)에 추가한다.

```
printf '/.claude/local/\n' >> .git/info/exclude
```

> [!NOTE]
> `.gitignore`가 아니라 `.git/info/exclude`를 쓰는 이유:
> - `.gitignore`는 git repo의 관리 대상 파일인 반면 `.git/info/exclude`는 로컬에만 적용됨.

## (선택) 자연어 트리거

wakeflow의 기본 사용 방침은 슬래시 커맨드를 통한 명시적 호출이다.
슬래시 커맨드 없이 자연어로도 워크플로를 발동하고 싶다면, 프로젝트 또는 전역
`CLAUDE.md`에 아래 스니펫을 추가한다. (플러그인은 자연어 자동 발동을 강제하지 않는다 —
"명시적 요청 없이는 시작하지 않는다"는 방침과 충돌하지 않도록 사용자가 직접 켠다.)

```markdown
## wakeflow 자연어 트리거

아래 의도가 감지되면 사용자에게 해당 커맨드 실행 여부를 물어보고, 확인 시 실행한다.

| 의도 (한국어) | 커맨드 |
|---|---|
| "task로 시작하자", "이거 작업 시작", "X 만들어볼게" | /wakeflow:task:start |
| "지금까지 한 거 task에 정리", "진행 상황 업데이트" | /wakeflow:task:update |
| "task 마무리", "끝났어", "정리해줘" | /wakeflow:task:end |
| "이건 따로 빼자", "issue로 등록", "나중에 처리" | /wakeflow:issue:create |
| "이슈 목록", "할 일 뭐 있지" | /wakeflow:issue:list |
```
