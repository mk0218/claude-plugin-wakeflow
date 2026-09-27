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

설치 후 wakeflow를 쓸 레포에서 `/wakeflow:tools:setup`을 실행하면 git 제외와 자연어 트리거를 항목마다 확인하며
설정한다. 설정을 되돌리려면 `/wakeflow:tools:cleanup`을 실행한다.

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

### tools — 설치·이전 보조

| 커맨드 | 설명 |
|---|---|
| `/wakeflow:tools:setup` | 사용 환경 설정 (git 제외·자연어 트리거, 항목마다 확인) |
| `/wakeflow:tools:cleanup` | setup이 추가한 설정 제거 (항목마다 확인) |
| `/wakeflow:tools:migrate` | 옛 위치(`.claude/local/`)의 데이터를 `.wakeflow/`로 이동 |

예전 버전에서 `.claude/local/`에 쌓인 데이터가 있으면 세션 시작 시 훅이 알려 주고, Claude가 migrate 실행을 제안한다.

## task/issue 데이터의 git 무시 (권장)

task/issue/archive 문서는 프로젝트의 `<project-root>/.wakeflow/` 아래에 쌓인다. 이 개인 작업 문서를
팀 레포 히스토리에 올리고 싶지 않다면 git에서 제외한다. `/wakeflow:tools:setup`이 전역 제외 파일
(`core.excludesFile`, 기본 `~/.config/git/ignore`) 또는 레포의 `.git/info/exclude` 중 고른 곳에 추가해 준다.
직접 추가할 경우:

```
printf '.wakeflow/\n' >> ~/.config/git/ignore     # 모든 레포
printf '.wakeflow/\n' >> .git/info/exclude        # 이 레포만
```

> [!NOTE]
> `.gitignore`가 아니라 위 두 파일을 쓰는 이유:
> - `.gitignore`는 git repo의 관리 대상 파일인 반면 두 파일은 로컬에만 적용됨.

## 개발: 커맨드 수정

`commands/`는 생성물이므로 직접 수정하지 않는다. 원본은 `src/commands/`(커맨드)와 `src/rules/`(여러 커맨드가
공유하는 규칙)이며, 커맨드 원본의 `<!-- include: <이름> -->` 줄이 `src/rules/<이름>.md` 본문으로 치환된다.

```
scripts/build           # src/ → commands/ 생성
scripts/build --check   # commands/가 원본과 어긋나면 실패
```

원본을 고친 뒤 `scripts/build`를 실행하고, 생성된 `commands/`도 함께 커밋한다.
GitHub Actions(`.github/workflows/build-check.yml`)가 PR과 main push마다 `scripts/build --check`를 실행한다.

커밋 시점에도 같은 검사를 하려면 clone마다 한 번 pre-commit hook을 켠다.

```
git config core.hooksPath .githooks
```

## (선택) 자연어 트리거

wakeflow의 기본 사용 방침은 슬래시 커맨드를 통한 명시적 호출이다.
슬래시 커맨드 없이 자연어로도 워크플로를 발동하고 싶다면 `/wakeflow:tools:setup`으로 `~/.claude/CLAUDE.md`에
트리거 블록을 추가한다. (플러그인은 자연어 자동 발동을 강제하지 않는다 — "명시적 요청 없이는 시작하지 않는다"는
방침과 충돌하지 않도록 사용자가 직접 켠다.) 넣는 내용은 `src/commands/tools/setup.md`에 있다.
