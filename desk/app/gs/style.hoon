^~
'''
body {
  font-family: "Inter", sans-serif;
  width: 100vw;
  height: 100vh;
  margin: 0;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}
main {
  height: 100%;
  width: 100%;
  flex-grow: 1;
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: flex-start;
}
button, select {
  border: none;
  border-radius: 2rem; 
  font-weight: 500;
  font-size: 1rem;
  padding: 0.7rem;
  margin-block: 0;
  margin-inline: 0.5rem;
  cursor: pointer;
}
button:hover, select:hover, .hut-selector:hover {
  opacity: 0.8;
}
button.active, select.active, .hut-selector:active {
  filter: brightness(1.2);
}
input, textarea {
  border: 1px solid #ccc;
  border-radius: 6px;
  padding: 12px;
  font-size: 12px;
  font-weight: 600;
}
textarea {
  min-width: 20rem;
}
.top-bar {
  height: 2.5rem;
  padding: 1rem;
  margin: 1rem;
  border: 1px solid #ccc;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
}
.gid-title {
  font-weight: 600;
  font-size: 1.3rem;
  margin-block: 0;
  margin-right: 40vw;
  color: #626160;
}
.no-squad-heading {
  font-weight: 600;
  font-size: 1.5rem;
  margin-top: 0;
  margin-inline: 2rem;
  color: #626160;
}
.huts-menu {
  box-sizing: border-box;
  height: 95%;
  min-width: 22rem;
  padding-inline: 1rem;
  padding-block: 2rem;
  margin-left: 1rem;
  border: 1px solid #ccc;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
}
.hut-form {
  margin-bottom: 0.5rem;
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-content: flex-start;
}
.section-heading {
  font-weight: 600;
  font-size: 1rem;
  margin-top: 0;
  margin-bottom: 1rem;
  color: #626160;
}
.hut-selector {
  border-radius: 2rem; 
  font-weight: 500;
  font-size: 1.2rem;
  padding: 1rem;
  margin-block: 1rem;
  margin-inline: 0;
  background-color: #F4F3F1;
  box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 6px;
  cursor: pointer;
}
.hut-selector.selected {
  background-color: #4eae75;
  color: white;
  cursor: default;
}
.content {
  box-sizing: border-box;
  height: 95%;
  padding-inline: 1rem;
  padding-bottom: 1rem;
  padding-top: 0;
  margin-inline: 1rem;
  border: 1px solid #ccc;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  align-items: center;
}
.msgs {
  box-sizing: border-box;
  width: 100%;
  height: 100%;
  padding-inline: 1rem;
  padding-bottom: 2rem;
  display: flex;
  flex-direction: column-reverse;
  justify-content: flex-start;
  align-items: flex-start;
  overflow-y: auto;
}
.msg {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin-block: 0.5rem;
}
.chat {
  width: 100%;
  padding-top: 1rem;
  border-top: 1px solid #ccc;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}
.people {
  min-width: 7rem;
  margin-right: 1rem;
}
.red-button {
  margin-inline: 0;
  margin-bottom: 2rem;
  background-color: #ff4136;
}
'''
