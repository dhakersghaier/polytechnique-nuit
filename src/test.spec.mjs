import { mount } from '@vue/test-utils';
import HelloWorld from '/home/dhaker/Desktop/Vue-js-Demo-main/src/components/HelloWorld.vue';

describe('HelloWorld', () => {
  it('renders properly', () => {
    const wrapper = mount(HelloWorld, {
      props: {
        msg: 'Hello, World!',
      },
    });

    expect(wrapper.text()).toContain('Hello, World!');
  });
});

