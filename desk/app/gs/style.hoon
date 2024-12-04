^~
'''
:root {
  --color-one: #F9FAF9;
  --color-two: lightgray;
  --color-three: gray;
  --color-four: #2A2C33;
}
.light {
  --color-one: #F9FAF9;
  --color-two: lightgray;
  --color-three: gray;
  --color-four: #2A2C33;
}
.dark {
  --color-one: #253237;
  --color-two: #5C6B73;
  --color-three: white;
  --color-four: white;
}
body {
  font-family: 'Metamorphous', serif;
  height: 100vh;
  margin: 0;
  display: flex;
  flex-direction: column;
}
main {
  flex-grow: 1;
  color: var(--color-four);
  background-color: var(--color-one);
  padding-top: 3rem;
  padding-inline: 3rem;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
}
button {
  font-family: 'Metamorphous', serif;
  padding-inline: 1rem;
  margin: 0.2rem;
  border-radius: 0.5rem;
  color: var(--color-one);
  background-color: var(--color-three);
  border: none;
  cursor: pointer;
  transition: transform 0.05s ease;
}
button:hover {
  transform: scale(1.05);
}
label {
  margin: 0.5rem;
  display: flex;
  flex-direction: column;
}
.edit-button-on {
  background-color: orange;
}
.delete-button {
  padding-inline: 0.4rem;
  padding-block: 0.2rem;
  margin: 0;
  border-radius: 1rem;
}
.title {
  border-bottom: 0.2rem solid var(--color-four);
}
.gs-form {
  padding: 0.5rem;
  margin: 1rem;
  background-color: var(--color-two);
  box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 6px;
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
}
.desk-buttons {
  margin-bottom: 0.7rem;
}
.desks-container {
  width: 100%;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: flex-start;
  flex-wrap: wrap;
}
.desk {
  width: 20rem;
  margin: 1rem;
  border-radius: 1rem;
  background-color: var(--color-two);
  box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 6px;
}
.desk-selector {
  font-size: 1.5rem;
  min-width: 7rem;
  padding-block: 1rem;
  padding-inline: 2rem;
  border-radius: 1rem;
  color: var(--color-one);
  background-color: var(--color-three);
  cursor: pointer;
  transition: transform 0.1s ease;
}
.desk-selector:hover {
  transform: scale(1.03);
}
.kv-table {
  max-height: 20rem;
  overflow: auto;
}
.kv-item {
  max-width: 15rem;
  margin: 1.5rem;
  padding: 0.9rem;
  border: 1px solid var(--color-three);
  border-radius: 0.7rem;
  display: flex;
  flex-direction: column;
  word-wrap: break-word;
}
.kv-item-top {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: flex-start;
}
.kv-name {
  font-size: 1.2rem;
}
.kv-mark {
  font-size: 0.9rem;
  margin-top: 0.4rem;
  margin-bottom: 0.8rem;
}
.kv-value {
  font-family: monospace;
  font-size: 1rem;
}
@media only screen and (max-width: 600px) {
  .gs-form {
    padding: 1.5rem;
    flex-direction: column;
    flex-wrap: unset;
  }
  .kv-table {
    max-height: unset;
  }
}
'''
