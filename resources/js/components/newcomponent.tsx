import { Button } from './ui/button';

export default function Newcomponent(props: { title: any; color: any }) {
    const { title, color } = props;
    return (
        <div>
            <Button className={`${color}`}>{title}</Button>
        </div>
    );
}
