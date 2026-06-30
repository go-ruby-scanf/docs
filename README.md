<p align="center"><img src="https://raw.githubusercontent.com/go-ruby-scanf/brand/main/social/go-ruby-scanf.png" alt="go-ruby-scanf/docs" width="720"></p>

# go-ruby-scanf/docs

Versioned documentation for [go-ruby-scanf](https://github.com/go-ruby-scanf),
built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) and
versioned with [mike](https://github.com/jimporter/mike). Published to the
`gh-pages` branch and served at <https://go-ruby-scanf.github.io/docs/>.

The organization landing page ([go-ruby-scanf.github.io](https://go-ruby-scanf.github.io))
links here.

## Local preview

```bash
python -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt
mkdocs serve                       # http://localhost:8000 (current sources)
mike serve                         # preview the versioned site
```

## Releasing a new docs version

```bash
mike deploy --push --update-aliases <version> latest
mike set-default --push latest
```
