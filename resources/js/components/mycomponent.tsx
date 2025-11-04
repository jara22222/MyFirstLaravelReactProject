import { Button } from './ui/button';

export default function Mycomponent(props: { title: any; color: any }) {
    const { title, color } = props;
    return <Button className={`${color} hover:bg-pink-500`}>{title}</Button>;
}
