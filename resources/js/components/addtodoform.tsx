import TodolistController from '@/actions/App/Http/Controllers/TodolistController';
import { Textarea } from '@headlessui/react';
import { Form } from '@inertiajs/react';
import { Loader2Icon } from 'lucide-react';
import InputError from './input-error';
import { Button } from './ui/button';
import { Input } from './ui/input';

export default function Addtodoform(props: {
    isEdit?: boolean;
    titleError?: string;
    descriptionError?: string;
}) {
    return (
        <>
            <Form
                {...TodolistController.store.form()}
                resetOnSuccess={['title', 'description']}
                disableWhileProcessing
                className="flex flex-col justify-center gap-3"
            >
                {({ processing, errors }) => (
                    <>
                        <div>
                            <span className="font-bold">Create Post</span>
                        </div>
                        <div className="flex flex-col justify-center gap-2">
                            <span className="self-start text-[12px] text-gray-500">
                                Title
                            </span>
                            <Input
                                minLength={1}
                                type="text"
                                name="title"
                                required
                                className="rounded-3xl border bg-gray-200 p-2 text-[12px]"
                            />
                            <div className="error-message text-[11px] text-red-600">
                                {props.titleError}
                            </div>
                            <InputError message={errors.title} />
                        </div>

                        <div className="flex flex-col justify-center gap-2">
                            <span className="self-start text-[12px] text-gray-500">
                                Description
                            </span>
                            <Textarea
                                maxLength={1500}
                                name="description"
                                required
                                id=""
                                className="max-h-90 min-h-50 rounded-3xl border bg-gray-200 p-2 text-[12px]"
                            ></Textarea>
                            <div className="error-message text-[11px] text-red-600">
                                {props.descriptionError}
                            </div>
                        </div>
                        <div className="flex flex-col justify-center">
                            <Button
                                disabled={processing}
                                type="submit"
                                className="cursor-pointer rounded-3xl"
                            >
                                {processing ? (
                                    <Loader2Icon className="animate-spin" />
                                ) : (
                                    'Create List'
                                )}
                            </Button>
                        </div>
                    </>
                )}
            </Form>
        </>
    );
}
