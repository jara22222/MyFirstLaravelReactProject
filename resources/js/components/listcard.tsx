import TodolistController from '@/actions/App/Http/Controllers/TodolistController';
import { Form } from '@inertiajs/react';
import { Edit, Menu, Trash } from 'lucide-react';
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
} from './ui/dropdown-menu';

export default function Listcard(props: {
    title: any;
    description: any;
    id: any;
}) {
    const { title, description, id } = props;

    return (
        <div className="flex flex-col justify-center gap-2 rounded border-l-8 border-emerald-600 p-2 shadow">
            <div className="flex flex-col justify-center gap-1">
                <div className="flex justify-between">
                    <span className="text-[14px]"># {id}</span>

                    <div>
                        <DropdownMenu>
                            <DropdownMenuTrigger className="cursor-pointer">
                                <Menu size={15} />
                            </DropdownMenuTrigger>
                            <DropdownMenuContent align="end">
                                <DropdownMenuItem>
                                    <Edit className="text-amber-600" />
                                    Edit
                                </DropdownMenuItem>
                                <DropdownMenuItem>
                                    <Form
                                        {...TodolistController.destroy.form(id)}
                                        disableWhileProcessing
                                    >
                                        {({ processing }) => (
                                            <button
                                                disabled={processing}
                                                type="submit"
                                                className="flex gap-2"
                                            >
                                                <Trash className="text-red-600" />
                                                Delete
                                            </button>
                                        )}
                                    </Form>
                                </DropdownMenuItem>
                            </DropdownMenuContent>
                        </DropdownMenu>
                    </div>
                </div>
                <span className="self-start text-[12px] text-gray-500">
                    Title
                </span>
                <span className="text-[14px]">{title}</span>
            </div>
            <div className="flex flex-col justify-center gap-1">
                <span className="self-start text-[12px] text-gray-500">
                    Desciption
                </span>
                <span className="text-[14px]">{description}</span>
            </div>
        </div>
    );
}
