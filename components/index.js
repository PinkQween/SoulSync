import * as Views from './views';

const register = (view) => {
    AppRegistry.registerComponent(view.name, () => view);
}

for (const view of Object.values(Views)) {
    register(view);
    console.log(`Registered ${view.name}`);
    console.log(view)
}